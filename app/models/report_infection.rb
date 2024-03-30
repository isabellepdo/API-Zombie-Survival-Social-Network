class ReportInfection < ApplicationRecord
	belongs_to :user, class_name: "User"
	belongs_to :whistleblower, class_name: "User"

	after_create :modifies_user_health, if: Proc.new { self.it_is_necessary_to_change_user_health? }

	def it_is_necessary_to_change_user_health?
		number_of_complaints = ReportInfection.where(user_id: self.user_id).count 

		return number_of_complaints >= 3
	end

	def modifies_user_health
		self.user.update_column(:health, :infected)
	end
end
