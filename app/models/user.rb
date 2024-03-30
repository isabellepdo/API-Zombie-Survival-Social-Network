class User < ApplicationRecord
	devise :database_authenticatable, authentication_keys: [:username]

	validates_presence_of :username

	enum gender: {
		female: 1,
		male: 2
	}

	enum health: {
		healthy: 1,
		infected: 2
	}
end
