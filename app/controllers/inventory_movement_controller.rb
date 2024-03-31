class InventoryMovementController < ApplicationController
  before_action :set_user
	before_action :set_item, only: [:add_item, :remove_item]

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

	private
	
	def set_user
		@user = User.find_by_username(params[:user])
	end

	def set_item
		@item = Item.find_by_name(params[:item])
	end
end
