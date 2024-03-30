class UsersController < ApplicationController
	def create
		user = User.new(user_params)

		if user.save
			render json: user, status: :created
		else
			render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def update_location
		user = User.find(params[:id])
		if user.update(user_location_params)
			render json: user, status: :ok
		else
			render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
		end
	end

	private

	def user_params
		params.require(:user).permit(:name, :age, :gender, :latitude, :longitude, :health, :username, :encrypted_password)
	end

	def user_location_params
		params.require(:user).permit(:latitude, :longitude)
	end
end