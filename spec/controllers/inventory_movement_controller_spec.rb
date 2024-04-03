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
				user = User.find_by_username('teste2')
				item = Item.find_by_name('Água')
				user_inventory = Inventory.where(user_id: user.id, item_id: item.id).last
				user_inventory.update_column(:amount, 3)

				get :remove_item, params: valid_params, format: :json
				expect(user.inventories.where(item_id: item.id).last.amount).to eq(2)
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
				post :remove_item, params: invalid_params, format: :json
				expect(response).to have_http_status(:not_found)
			end
		end
	end

	describe 'POST #barter' do
		context 'with valid JSON parameters and valid users/items' do
			let!(:item1) { Item.create(name: 'Item1', points_for_barter: 1) }
			let!(:item2) { Item.create(name: 'Item2', points_for_barter: 2) }
			let!(:user1) { User.create(name: 'User1', username: 'user1', encrypted_password: 'password') }
			let!(:user2) { User.create(name: 'User2', username: 'user2', encrypted_password: 'password') }
			let(:valid_params_user1) do
				{
					user: 'user1',
					item: 'Item1',
					value: 3
				}
			end
			let(:valid_params_user2) do
				{
					user: 'user2',
					item: 'Item2',
					value: 2
				}
			end
			let(:valid_barter_params) do
				{
					users: [
						{
							username: 'user1',
							items: [
								{ name: 'Item1', amount: 2 }
							]
						},
						{
							username: 'user2',
							items: [
								{ name: 'Item2', amount: 1 }
							]
						}
					]
				}
			end
	
			it 'successfully performs the barter between users' do
				post :barter, body: valid_barter_params.to_json, format: :json
				expect(response).to have_http_status(:ok)
			end
	
			it 'updates the inventories with the correct amounts after the barter' do
				get :add_item, params: valid_params_user1, format: :json
				get :add_item, params: valid_params_user2, format: :json
				get :barter, body: valid_barter_params.to_json, format: :json
				
				expect(user1.inventories.find_by(item_id: item1.id).amount).to eq(1)
				expect(user1.inventories.find_by(item_id: item2.id).amount).to eq(1)
				expect(user2.inventories.find_by(item_id: item1.id).amount).to eq(2)
				expect(user2.inventories.find_by(item_id: item2.id).amount).to eq(1)
			end
		end
	
		context 'with invalid JSON parameters' do
			let(:invalid_barter_params) do
				{
					invalid_key: 'value'
				}
			end
	
			it 'returns an error if JSON structure is invalid' do
				post :barter, body: invalid_barter_params.to_json, format: :json
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	
		context 'when one or both users are not found' do
			let(:invalid_barter_params) do
				{
					users: [
						{
							username: 'non_existing_user',
							items: [{ name: 'Item1', amount: 1 }]
						},
						{
							username: 'user2',
							items: [{ name: 'Item2', amount: 1 }]
						}
					]
				}
			end
	
			it 'returns an error if one or both users are not found' do
				post :barter, body: invalid_barter_params.to_json, format: :json
				expect(response).to have_http_status(:not_found)
			end
		end
	
		context 'when one or both items are not found' do
			let(:invalid_barter_params) do
				{
					users: [
						{
							username: 'user1',
							items: [{ name: 'NonExistingItem', amount: 1 }]
						},
						{
							username: 'user2',
							items: [{ name: 'Item2', amount: 1 }]
						}
					]
				}
			end
	
			it 'returns an error if one or both items are not found' do
				post :barter, body: invalid_barter_params.to_json, format: :json
				expect(response).to have_http_status(:not_found)
			end
		end
	
		context 'when exchange does not satisfy points rules' do
			let!(:item1) { Item.create(name: 'Item1', points_for_barter: 1) }
			let!(:item2) { Item.create(name: 'Item2', points_for_barter: 4) }
			let!(:user1) { User.create(name: 'User1', username: 'user1', encrypted_password: 'password') }
			let!(:user2) { User.create(name: 'User2', username: 'user2', encrypted_password: 'password') }
			let(:invalid_barter_params) do
				{
					users: [
						{
							username: 'user1',
							items: [
								{ name: 'Item1', amount: 1 }
							]
						},
						{
							username: 'user2',
							items: [
								{ name: 'Item2', amount: 1 }
							]
						}
					]
				}
			end
	
			it 'returns an error if exchange does not satisfy points rules' do
				get :barter, body: invalid_barter_params.to_json, format: :json

				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	end	
end
