require 'sidekiq/api'

class SendEmailJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # ignore
    puts exception
  end

  def perform(lender_id, borrower_id, item_id, to_which)
  	if(!destroy_on_change)
	  	@lender = User.find(lender_id)
	  	@borrower = User.find(borrower_id)
	  	@item = Item.find(item_id)
	  	borrowed_item = BorrowedItem.find_by_item_id(item_id)
	  	@days = ((borrowed_item.due_date.to_i - Time.now.to_i) / 1.day) 
	    # Deliver due date email
	    if(to_which == "smart_alert") 
	    	UserMailer.smart_due_date_alert(@borrower, @item, @days).deliver_now
	    elsif(to_which == "Lender")
	    	UserMailer.due_date_alert(@lender, @item).deliver_now
	    else
	    	UserMailer.due_date_alert(@borrower, @item).deliver_now
	    end
	end
	create_next_alert
  end

  #will delete all non-executed scheduled alerts for this user if there's new due date
  def self.delete_prev_entries(item_id)
  	scheduled_queue = Sidekiq::ScheduledSet.new
  	scheduled_queue.each do |job|
        puts "looping; job item_id = #{job.args[0]['arguments'][2]}"
  		if(job.args[0]['arguments'][2].to_i == item_id)
  			puts "found match item_id #{job.args[0]['arguments'][2]}"
  			item = BorrowedItem.find_by_item_id(item_id)
  			if(item)
		  		due_ext = item.temp_due_date
		  		if(due_ext != nil) #due date updated, must be old schedule
		  			job.delete
		  		end
		  	end 
  		end
  	end
  end


  # in case if user's notification preferences has changed to false
  # also handles if user does not exist anymore
  def destroy_on_change
	@item = BorrowedItem.find_by_item_id(self.arguments[2])
  	@notif_borrower = Notification.find_by_user_id(self.arguments[1])
  	@borrower = User.find(self.arguments[1])
  	@lender = User.find(self.arguments[0])
  	delete = false
  	if(self.arguments[3] == "smart_alert")
  		if(!@borrower ||!@item)
  			delete = true
  		end
	  	if(@notif_borrower && !@notif_borrower.i_due_alert)
	  		delete = true
	  	end
	  	if(@item && @item.returned_on != nil)
	  		delete = true
	  	end
	  	return delete
	elsif(self.arguments[3] == "Lender")
		if(!@lender)
			return true
		end
	else
		if(!@borrower)
			return true
		end
  	end 
  end

  #create next alert that will send user emails after due date
  def create_next_alert
  	@item = BorrowedItem.find_by_item_id(self.arguments[2])
  	if(self.arguments[3] == "Borrower" && @item && @item.returned_on == nil)
  		SendEmailJob.set(wait: 1.days).perform_later(self.arguments[0], self.arguments[1], self.arguments[2], self.arguments[3])
  	end
  end
end
