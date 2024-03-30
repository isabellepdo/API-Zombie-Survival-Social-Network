require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	describe 'POST #create' do
		context 'with valid parameters' do
			let(:valid_params) do
				{
					user: {
						name: 'John Doe',
						age: 30,
						gender: 'male',
						latitude: 123.456,
						longitude: 456.789,
						health: 'healthy',
						username: 'johndoe',
						encrypted_password: 'password'
					}
				}
			end

			it 'creates a new user' do
				post :create, params: valid_params
				expect(response).to have_http_status(:created)
			end
		end

		context 'with invalid parameters' do
			let(:invalid_params) { { user: { name: '', age: 30 } } }

			it 'does not create a new user' do
				post :create, params: invalid_params
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	end

	describe 'PATCH #update_location' do
		let!(:user) { User.create(name: 'John', age: 30, gender: 'male', latitude: 0, longitude: 0, health: 'healthy', username: 'john', encrypted_password: 'password') }

		context 'with valid parameters' do
			let(:valid_params) { { id: user.id, user: { latitude: 123.456, longitude: 456.789 } } }

			it 'updates the user location' do
				patch :update_location, params: valid_params
				expect(response).to have_http_status(:ok)
			end
		end

		context 'with invalid parameters' do
			let(:invalid_params) { { id: user.id, user: { latitude: '', longitude: '' } } }

			it 'does not update the user location' do
				patch :update_location, params: invalid_params
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	end
end
