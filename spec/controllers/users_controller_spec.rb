require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	describe 'POST #create' do
		context 'with valid parameters' do
			let(:valid_params) do
				{
					user: {
						name: 'Fulano',
						age: 30,
						gender: 'male',
						latitude: 123.123,
						longitude: 321.321,
						health: 'healthy',
						username: 'fulano',
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
			let(:invalid_params) { { user: { username: '', age: 30 } } }

			it 'does not create a new user' do
				post :create, params: invalid_params
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	end

	describe 'PATCH #update_location' do
		let!(:user) { User.create(name: 'Cicrano', age: 30, gender: 'male', latitude: 0, longitude: 0, health: 'healthy', username: 'cicrano', encrypted_password: 'password') }

		context 'with valid parameters' do
			let(:valid_params) { { id: user.id, user: { latitude: 123.456, longitude: 456.789 } } }

			it 'updates the user location' do
				patch :update_location, params: valid_params
				expect(response).to have_http_status(:ok)
			end
		end

		context 'with invalid parameters' do
			let(:invalid_params) { { id: user.id, user: { latitude: '', longitude: '' } } }

			it 'does not update the user location because invalid data' do
				patch :update_location, params: invalid_params
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end

		context 'with invalid user' do
			let(:invalid_params) { { id: 999, user: { latitude: '', longitude: '' } } }

			it 'does not update the user location because invalid user' do
				patch :update_location, params: invalid_params
				expect(response).to have_http_status(:not_found)
			end
		end
	end

	describe 'POST #report_user' do
    let(:whistleblower) { User.create(name: 'Deltrano', age: 30, gender: 'male', latitude: 0, longitude: 0, health: 'healthy', username: 'deltrano', encrypted_password: 'password') }
		let(:user) { User.create(name: 'Futuro Infectado', age: 30, gender: 'male', latitude: 0, longitude: 0, health: 'healthy', username: 'infectado', encrypted_password: 'password') }


    context 'when user to report exists' do
      context 'when report is successfully created' do
        it 'returns status :ok' do
          post :report_user, params: { id: user.id, whistleblower_id: whistleblower.id }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when report to same user has already been made' do
        before do
          ReportInfection.create(user_id: user.id, whistleblower_id: whistleblower.id)
        end

        it 'returns status :unprocessable_entity' do
          post :report_user, params: { id: user.id, whistleblower_id: whistleblower.id }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          post :report_user, params: { id: user.id, whistleblower_id: whistleblower.id }
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Your report to this user has already been made.' })
        end
      end
    end

    context 'when user to report does not exist' do
      it 'returns status :not_found' do
        post :report_user, params: { id: 'invalid_id', whistleblower_id: whistleblower.id }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        post :report_user, params: { id: 'invalid_id', whistleblower_id: whistleblower.id }
        expect(JSON.parse(response.body)).to eq({ 'error' => 'User not found' })
      end
    end
  end
end