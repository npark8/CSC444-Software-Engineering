class NotificationsController < ApplicationController
	before_action :authenticate_user_before_db_update
	def edit
		@user = User.find(params[:user_id])
		@notification = Notification.find(params[:id])
	end

	def update
		@user = User.find(params[:user_id])
	    @notification = Notification.find(params[:id])

	    if @notification.update(notification_params)
	      flash[:success_msg] = "Email notification preferences are successfully updated!"
	      redirect_to user_notification_path(@user.id, @notification.id)
	    else
	      flash[:failure_msg] = "Something went wrong!"
	      render 'edit'
	    end
	end

	def show
		@user = User.find(params[:user_id])
	    @notification = Notification.find(params[:id])
	end
	private
	def notification_params
		params.require(:notification).permit(:id,:user_id, :i_req_by_others, :i_req_approval_alert, :i_due_alert)
	end


	
end
