class User < ApplicationRecord
	devise :database_authenticatable, authentication_keys: [:username]

	validates_presence_of :username

	after_create :set_health, if: Proc.new { self.health.nil? }

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
end
