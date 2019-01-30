class ReportUsersController < ApplicationController
	def create
       @user = current_user
		@reportUser= ReportUser.create!(report_params)
       redirect_to @user
	 end
	def new
		@reportUser= ReportUser.new
	end
	
	def index 
		if current_user.admin == false
			redirect_to current_user
		end
		@reports = ReportUser.all

	end

	def show 
		@reports = ReportUser.all

	end
	def destroy
		@reports = ReportUser.all
		@reports.delete(params[:id])
		redirect_to report_user_path
	end  
	private
	def report_params
		params.permit(:reporter_id, :reportee_id,:reason,:comment)
	end
end
