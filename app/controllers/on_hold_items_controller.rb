class OnHoldItemsController < ApplicationController
	before_action :find_user_set_item_id, only: [:create, :destroy]
	before_action :authenticate_user_before_db_update, except: []

	def new
		@user = User.find(params[:user_id])
		@item = Item.find(params[:item_id])
		@on_hold_item = OnHoldItem.new
		respond_to do |format|
	      format.js
	    end
	end
	def create
		@on_hold_item = @user.on_hold_items.create(on_hold_item_params)
		#send borrow request notification if preference is set
		@notif = Notification.find_by_user_id(@user.id)
		if @on_hold_item.save
			item = Item.find(@on_hold_item.item_id)
		    if @notif.i_req_by_others
				lender = User.find(item.user_id)
				borrower = User.find(@on_hold_item.user_id)
				UserMailer.new_borrow_request(lender, borrower, item).deliver_later
			end
			flash[:success_msg] = "Borrow request for item [#{item.name}] has been sent!"
		else
			flash[:failure_msg] = "Information did not meet requirements"
		end
		redirect_to user_items_path(@user.id)
	end
	def destroy
   		@on_hold_item = @user.on_hold_items.find_by_item_id(@item_id)
    	item = Item.find(@on_hold_item.item_id)
    	@on_hold_item.destroy
    	if(@on_hold_item.destroy)
    		flash[:success_msg] = "Borrow request for [#{item.name}] has been canceled!"
    	end
    	redirect_to user_items_path(@user.id)
	end

	def update_request_status
		@on_hold_item = OnHoldItem.find(params[:on_hold_item_id])
		@item = Item.find(@on_hold_item.item_id)
		@notif = Notification.find_by_user_id(@on_hold_item.user_id)
		lender = User.find(@item.user_id)
		borrower = User.find(@on_hold_item.user_id)
		if params[:result] == "approved"
			@on_hold_item.approve_req
			#send borrower status update
			if @on_hold_item.save 
				if @notif.i_req_approval_alert
					UserMailer.accept_borrow_request(lender, borrower, @item, params[:result]).deliver_later
				end
				flash[:success_msg] = "You have approved borrow request for item [#{@item.name}] from [#{borrower.fname}]!"
			else
				flash[:failure_msg] = "Something went wrong!"
			end
			#@item.lent_out <-- will do this when borrowed item is created
			redirect_to  user_items_path(params[:user_id])
		elsif params[:result] == "denied"
			@on_hold_item.reject_req
			#send borrower status update
			if @on_hold_item.save
				if @notif.i_req_approval_alert
					UserMailer.accept_borrow_request(lender, borrower, @item, params[:result]).deliver_later
				end
				flash[:success_msg] = "You have rejected borrow request for item [#{@item.name}] from [#{borrower.fname}]!"
			else
				flash[:failure_msg] = "Something went wrong!"
			end
			redirect_to  user_items_path(params[:user_id])
		end
	end

	private
	 def on_hold_item_params
 		 params.require(:on_hold_item).permit(:id,:item_id,:user_id, :req_on, :due_date)
 	 end
 	 def find_user_set_item_id
 	 	@user = User.find(params[:user_id])
		@item_id = params[:id]
		if(!@item_id)
			@item_id = params[:item_id]
		end
 	 end
end
