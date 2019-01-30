class UserMailer <ActionMailer::Base
	default from: 'bolendbot@gmail.com'
	def registration_confirmation(user)
		@user = user
		#mail(:to => "#{user.fname} <#{user.email}>", :subject => "Please confirm your registration")
		#mail(:to @user.email, subject: 'Register plz')
		mail to: @user.email, subject: "Registration Confirmation for Bolend"
	end 
	def password_reset(user)
		@user = user
		mail to: @user.email, subject: "Bolend Password Reset"
	end

  def new_friend_request(requirer,requiree)
    @requirer = requirer 
    @requiree = requiree
    mail to: @requiree.email, subject: "Bolend: friend request from #{@requirer.fname.capitalize} #{@requirer.lname.capitalize}."
  end
  
  def accept_friend_request(requirer,requiree)
    @requirer = requirer
    @requiree = requiree
    mail to: @requirer.email, subject: "Bolend: #{@requiree.fname.capitalize} #{@requiree.lname.capitalize} have accepted your friend request."
  end

  def new_borrow_request(lender, borrower, item)
  	@lender = lender
  	@borrower = borrower
  	@item = item
  	mail to: @lender.email, subject: "Bolend: borrow request from #{@borrower.fname.capitalize} #{@borrower.lname.capitalize}"
  end

  def accept_borrow_request(lender, borrower, item, status)
  	@lender = lender
  	@borrower = borrower
  	@item = item
  	@status = status
  	mail to: @borrower.email, subject: "Bolend: #{@lender.fname.capitalize} #{@lender.lname.capitalize} has #{@status.downcase} your borrow request"
  end

  def new_extension_request(lender, borrower, item)
  	@lender = lender
  	@borrower = borrower
  	@item = item
  	mail to: @lender.email, subject: "Bolend: due date extension request from #{@borrower.fname.capitalize} #{@borrower.lname.capitalize}"
  end  

  def accept_extension_request(lender, borrower, item, status)
  	@lender = lender
  	@borrower = borrower
  	@item = item
  	@status = status
  	mail to: @borrower.email, subject: "Bolend: #{@lender.fname.capitalize} #{@lender.lname.capitalize} has #{@status.downcase} your extension request"
  end  

  def smart_due_date_alert(borrower, item, days)
  	@borrower = borrower
  	@item = item
  	@days = days
  	mail to: @borrower.email, subject: "Bolend: #{@item.name.capitalize} is due in #{@days} day(s). Please take an action"
  end  

  def due_date_alert(alert_to, item)
  	@alert_to = alert_to
  	@item = item
  	mail to: @alert_to.email, subject: "Bolend: #{@item.name} - item is DUE. Please take an action"
  end  

  def confirm_pickup(alert_to, item)
  	@alert_to = alert_to
  	@item = item
  	mail to: @alert_to.email, subject: "Bolend: #{@item.name} - item pickup confirmation"
  end  

  def confirm_return(alert_to, item)
  	@alert_to = alert_to
  	@item = item
  	mail to: @alert_to.email, subject: "Bolend: #{@item.name} - item return confirmation"
  end  
end