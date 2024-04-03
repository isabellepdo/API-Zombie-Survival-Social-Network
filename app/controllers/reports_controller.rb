class ReportsController < ApplicationController
	before_action :set_users_types, only: [:percentage_of_healthy_users, :percentage_of_non_infected_users]

	def percentage_of_healthy_users
		render json: { percentage_of_healthy_users: (100 * @healthy_users ) / (@healthy_users + @infected_users) }
	end

	def percentage_of_non_infected_users
		render json: { percentage_of_healthy_users: (100 * @infected_users ) / (@healthy_users + @infected_users) }
	end

	def quantity_of_each_type_of_item_per_user

	end

	def number_of_points_lost_by_infected_users
		number_of_points_lost = 0

		User.infected.each do |user|
			user.inventories.each do |inventory|
				points_for_item = inventory.item.points_for_barter
				number_of_points_lost += inventory.amount * points_for_item
			end
		end

		render json: { number_of_points_lost_by_infected_users: number_of_points_lost }
	end

	private
	
	def set_users_types
		@healthy_users = User.healthy.count
		@infected_users = User.infected.count
	end
end
