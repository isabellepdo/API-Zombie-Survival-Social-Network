class Inventory < ApplicationRecord
	belongs_to :user, class_name: "User"
	belongs_to :item, class_name: "Item"

	validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
