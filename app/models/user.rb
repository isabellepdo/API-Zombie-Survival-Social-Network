class User < ApplicationRecord
  devise :database_authenticatable, authentication_keys: [:username]

  enum gender: {
    female: 1,
    male: 2
  }

  enum health: {
    healthy: 1,
    infected: 2
  }
end
