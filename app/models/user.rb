class User < ApplicationRecord
	devise :database_authenticatable, authentication_keys: [:username]

	has_many :inventories, class_name: "Inventory"

	validates_presence_of :username

	after_create :set_health, if: Proc.new { self.health.nil? }
	after_create :create_inventary

	enum gender: {
		female: 1,
		male: 2
	}

	enum health: {
		healthy: 1,
		infected: 2
	}

	def set_health
		self.update_column(:health, :healthy)
	end

	def create_inventary
		possible_items = Item.all

		possible_items.each do |item|
			Inventory.create!(
				user_id: self.id,
      	item_id: item.id,
      	amount: 0
			)
		end
	end
end
