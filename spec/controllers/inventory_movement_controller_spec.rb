require 'rails_helper'

RSpec.describe InventoryMovementController, type: :controller do
	describe 'POST #add_item' do
		context 'with valid JSON parameters' do
			let!(:item) { Item.create(name: 'Água', points_for_barter: 4)}
			let!(:user) { User.create(name: 'Teste 1', age: 30, gender: 'male', latitude: 0, longitude: 0, health: 'healthy', username: 'teste1', encrypted_password: 'password') }
			let(:valid_params) do
				{
					user: 'teste1',
					item: 'Água',
					value: 1
				}
			end

			it 'adds an item to the inventory' do
				get :add_item, params: valid_params, format: :json
				expect(response).to have_http_status(:ok)
			end

			it 'updates the inventory with the correct amount' do
				post :add_item, params: valid_params, format: :json
				inventory = Inventory.last
				expect(inventory.amount).to eq(1)
			end
		end

		context 'with invalid JSON parameters' do
			let(:invalid_params) do
				{
					user: 'non_existing_user',
					item: 'item_name',
					value: 1
				}
			end

			it 'returns an error if user is not found' do
				post :add_item, params: invalid_params, format: :json
				expect(response).to have_http_status(:not_found)
			end
		end
	end

	describe 'POST #remove_item' do
		context 'with valid JSON parameters' do
			let!(:item) { Item.create(name: 'Água', points_for_barter: 4)}
			let!(:user) { User.create(name: 'Teste 2', age: 30, gender: 'male', latitude: 0, longitude: 0, health: 'healthy', username: 'teste2', encrypted_password: 'password') }
			let(:valid_params) do
				{
					user: 'teste2',
					item: 'Água',
					value: 1
				}
			end

			it 'adds an item to the inventory' do
				user_inventory = Inventory.where(user_id: User.find_by_username('teste2').id, item_id: Item.find_by_name('Água').id).last
				user_inventory.update_column(:amount, 3)

				get :remove_item, params: valid_params, format: :json
				expect(response).to have_http_status(:ok)
			end

			it 'updates the inventory with the correct amount' do
				user_inventory = Inventory.where(user_id: User.find_by_username('teste2').id, item_id: Item.find_by_name('Água').id).last
				user_inventory.update_column(:amount, 3)
				byebug
				get :remove_item, params: valid_params, format: :json
				expect(user_inventory.amount).to eq(2)
			end
		end

		# context 'with invalid JSON parameters' do
		# 	let(:invalid_params) do
		# 		{
		# 			user: 'non_existing_user',
		# 			item: 'item_name',
		# 			value: 1
		# 		}
		# 	end

		# 	it 'returns an error if user is not found' do
		# 		post :remove_item, params: invalid_params, format: :json
		# 		expect(response).to have_http_status(:not_found)
		# 	end
		# end
	end

	# describe 'POST #barter' do
	# 	# Write your test cases for the barter action
	# end
end
