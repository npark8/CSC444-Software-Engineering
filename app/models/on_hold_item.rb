class OnHoldItem < ApplicationRecord
	belongs_to :item
	belongs_to :user

	validate :due_date_cannot_be_in_the_past

	def due_date_cannot_be_in_the_past
	    if due_date.present? && due_date <= Date.today
	      errors.add(:due_date, "can't be in the past")
	    end
	end

	def approve_req
		update_attributes(approved: 'Approved')
	end

	def reject_req
		update_attributes(approved: 'Denied')
	end

	def returned
		update_attributes(approved: 'Returned')
	end

	def set_null
		update_attributes(approved: nil)
	end
end
