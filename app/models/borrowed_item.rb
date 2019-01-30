class BorrowedItem < ApplicationRecord
	belongs_to :item
	belongs_to :user

	validate :due_date_cannot_be_in_the_past

	def due_date_cannot_be_in_the_past
	    if due_date.present? && due_date <= Date.today
	      errors.add(:due_date, "can't be in the past")
	    end
	end

	def set_returned_date
		update_attributes(returned_on: Time.now.strftime("%d/%m/%Y"))
	end

	def approve_req
		update_attributes(approved: 'Approved')
	end

	def reject_req
		update_attributes(approved: 'Denied')
	end

	def set_status
		update_attributes(approved: 'pending')
	end

	def update_due_date
		new_due = self.temp_due_date
		update_attributes(due_date: new_due)
	end
end
