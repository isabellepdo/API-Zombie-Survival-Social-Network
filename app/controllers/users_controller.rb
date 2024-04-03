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
		if User.where(id: params[:id]).any?
			user = User.find(params[:id])

			if (params[:latitude].present? && params[:longitude].present?) || (params[:user][:latitude].present? && params[:user][:longitude].present?)
				if user.update(user_location_params)
					render json: user, status: :ok
				else
					render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
				end
			else
				render json: { error: "Request data is missing" }, status: :unprocessable_entity
			end
		else
			render json: { error: "User not found" }, status: :not_found
		end
	end

	def report_user
		user = User.find_by_username(params[:user])
		whistleblower = User.find_by_username(params[:whistleblower])

		if user.present? && whistleblower.present?
			if ReportInfection.where(user_id: user.id, whistleblower_id: whistleblower.id).empty?
				if ReportInfection.new(user_id: user.id, whistleblower_id: whistleblower.id).save
					render json: user, status: :ok
				else
					render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
				end
			else
				render json: { error: "Your report to this user has already been made." }, status: :unprocessable_entity
			end
		else
			render json: { error: "User not found" }, status: :not_found
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