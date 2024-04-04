class InventoryMovementController < ApplicationController
	before_action :set_user, only: [:add_item, :remove_item]
	before_action :set_item, only: [:add_item, :remove_item]
	before_action :set_json_barder, only: [:barter]
	before_action :check_json_struct, only: [:barter]
	before_action :set_and_check_valid_users, only: [:barter]
	before_action :check_valids_items_for_trade, only: [:barter]

	def add_item
		if @user.present?
			inventory_to_be_used = Inventory.where(user_id: @user.id, item_id: @item.id).last

			if inventory_to_be_used.present?
				value = inventory_to_be_used.amount.to_i + params[:value].to_i

				if inventory_to_be_used.update_column(:amount, value)
					render json: inventory_to_be_used, status: :ok
				else
					render json: { errors: inventory_to_be_used.errors.full_messages }, status: :unprocessable_entity
				end
			else
				render json: { error: "Request data is missing" }, status: :unprocessable_entity
			end
		else
			render json: { error: "User not found" }, status: :not_found
		end
	end

	def remove_item
		if @user.present?
			inventory_to_be_used = Inventory.where(user_id: @user.id, item_id: @item.id).last

			if inventory_to_be_used.present?
				value = inventory_to_be_used.amount.to_i - params[:value].to_i

				if inventory_to_be_used.update_column(:amount, value)
					render json: inventory_to_be_used, status: :ok
				else
					render json: { errors: inventory_to_be_used.errors.full_messages }, status: :unprocessable_entity
				end
			else
				render json: { error: "Request data is missing" }, status: :unprocessable_entity
			end
		else
			render json: { error: "User not found" }, status: :not_found
		end
	end

	def barter
		begin
			Inventory.transaction do
				@user1_data['items'].each do |item|
					item_in_table = Item.find_by_name(item['name'])
	
					user_inventory_item = Inventory.where(user_id: @user1.id, item_id: item_in_table.id).last
					final_quantity_user = user_inventory_item.amount.to_i - item['amount'].to_i
	
					user_inventory_item.update_column(:amount, final_quantity_user)
					raise ActiveRecord::Rollback unless user_inventory_item.save
	
					other_user_inventory_item = Inventory.where(user_id: @user2.id, item_id: item_in_table.id).last
					final_quantity_other_user = other_user_inventory_item.amount.to_i + item['amount'].to_i
					other_user_inventory_item.update_column(:amount, final_quantity_other_user)
					raise ActiveRecord::Rollback unless other_user_inventory_item.save
				end
	
				@user2_data['items'].each do |item|
					item_in_table = Item.find_by_name(item['name'])
	
					user_inventory_item = Inventory.where(user_id: @user2.id, item_id: item_in_table.id).last
					final_quantity_user = user_inventory_item.amount.to_i - item['amount'].to_i
	
					user_inventory_item.update_column(:amount, final_quantity_user)
					raise ActiveRecord::Rollback unless user_inventory_item.save
	
					other_user_inventory_item = Inventory.where(user_id: @user1.id, item_id: item_in_table.id).last
					final_quantity_other_user = other_user_inventory_item.amount.to_i + item['amount'].to_i
					other_user_inventory_item.update_column(:amount, final_quantity_other_user)
					raise ActiveRecord::Rollback unless other_user_inventory_item.save
				end
			end
	
			render json: { message: "Trade successful" }, status: :ok
		rescue ActiveRecord::Rollback
			render json: { error: "Failed to update inventories" }, status: :unprocessable_entity
		end
	end

	private
	
	def set_user
		@user = User.find_by_username(params[:user])
	end

	def set_item
		@item = Item.find_by_name(params[:item])
	end

	def set_json_barder
		@barter_data = JSON.parse(request.body.read)
	end

	def check_json_struct
		unless @barter_data['users'].is_a?(Array) && @barter_data['users'].size == 2
			render json: { error: "Invalid JSON structure" }, status: :unprocessable_entity
			return
		end
	end

	def set_and_check_valid_users
		@user1_data = @barter_data['users'][0]
		@user2_data = @barter_data['users'][1]
	
		@user1 = User.find_by_username(@user1_data['username'])
		@user2 = User.find_by_username(@user2_data['username'])
	
		# Check if both users exist
		unless @user1 && @user2
			render json: { error: "One or both users not found" }, status: :not_found
			return
		end

		# Check if users are healthy
		unless @user1.healthy? && @user2.healthy?
			render json: { error: "Some of the users are not healthy" }, status: :not_found
			return
		end
	end

	def check_valids_items_for_trade
		@points_for_user_1 = 0
		@user1_data['items'].each do |item|
			item_in_table = Item.find_by_name(item['name'])

			if item_in_table
				@points_for_user_1 += (item['amount'].to_i * item_in_table.points_for_barter)
			else
				render json: { error: "One or both items not found" }, status: :not_found
				return
			end
		end

		@points_for_user_2 = 0
		@user2_data['items'].each do |item|
			item_in_table = Item.find_by_name(item['name'])

			if item_in_table
				@points_for_user_2 += (item['amount'].to_i * item_in_table.points_for_barter)
			else 
				render json: { error: "One or both items not found" }, status: :not_found
				return
			end
		end

		if @points_for_user_1 != @points_for_user_2
			render json: { error: "Exchange does not satisfy points rules" }, status: :unprocessable_entity
			return
		end
	end
end
