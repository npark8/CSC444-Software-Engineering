class BorrowedItemsController < ApplicationController
  before_action :authenticate_user_before_db_update, except: [:new, :create]
  def new
      @user = User.find(params[:user_id])
      @on_hold_item = OnHoldItem.find(params[:on_hold_item_id])
      @borrowed_item = BorrowedItem.new
  end

  def edit
    @user = User.find(params[:user_id])
    @item = Item.find(params[:id])
    @borrowed_item = @user.borrowed_items.find(params[:id])
  end
  def create
    @user =  User.find(params[:user_id])
    @borrowed_item = @user.borrowed_items.create(borrowed_item_params)    
    if @borrowed_item.save     
      @item = Item.find_by_id(@borrowed_item.item_id)
      @item.lent_out
      @curr_user = User.find_by_id(@item.user_id)
      
      @notif = Notification.find_by_user_id(@borrowed_item.user_id)
      lender = User.find(@item.user_id)
      borrower = User.find(@borrowed_item.user_id)
      #add due date smart alerts for borrower to the delay queue 
      #email will be sent 1 week before, 3 days before and the day before due date
      duration = ((@borrowed_item.due_date.to_i - Time.now.to_i) / 1.day)
      if @notif.i_due_alert
        if duration-7 > 0
          SendEmailJob.set(wait: (duration-7).days).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
        end
        if duration-3 > 0
          SendEmailJob.set(wait: (duration-3).days).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
        end
        if duration-1 > 0
          SendEmailJob.set(wait: (duration-1).days).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
        end
      end
      #unconditional mailer to be delivered to both lender/borrower on due date
      SendEmailJob.set(wait: duration.days).perform_later(lender.id, borrower.id, @item.id, "Borrower")
      SendEmailJob.set(wait: duration.days).perform_later(lender.id, borrower.id, @item.id, "Lender")
      UserMailer.confirm_pickup(borrower, @item).deliver_later 
      UserMailer.confirm_pickup(lender, @item).deliver_later 
      
      flash[:success_msg] = "You have confirmed that item [#{@item.name}] has been lent out. Due date reminders have been scheduled for [#{borrower.fname}] at your convenience!"
      redirect_to user_items_path(@curr_user)
    else
      flash[:failure_msg] = "Something went wrong!"
      render :new
    end
  end

  def update
    @user = User.find(params[:user_id])
    @borrowed_item = @user.borrowed_items.find(params[:id])
    @item = Item.find(@borrowed_item.item_id)

    if @borrowed_item.update(borrowed_item_params)
      @borrowed_item.set_status
      #conditional mailer
      #send extension request alert to lender
      @notif = Notification.find_by_user_id(@item.user.id)
      lender = User.find(@item.user_id)
      borrower = User.find(@borrowed_item.user_id)
      if @notif.i_req_by_others  
        UserMailer.new_extension_request(lender, borrower, @item).deliver_later       
      end
      flash[:success_msg] = "Due date extension request for [#{@item.name}] has been sent to [#{lender.fname}]!"
      redirect_to user_items_path(@user.id)
    else
      flash[:failure_msg] = "Something went wrong!"
      render 'edit'
    end
  end

  def update_ext_status
    @borrowed_item = BorrowedItem.find(params[:borrowed_item_id])
    @item = Item.find(@borrowed_item.item_id)
    @notif = Notification.find_by_user_id(@borrowed_item.user_id)
    lender = User.find(@item.user_id)
    borrower = User.find(@borrowed_item.user_id)
    if params[:result] == "approved"
        @borrowed_item.approve_req
        @borrowed_item.update_due_date
         @borrowed_item.save
        #send extension status update to borrower
          if @notif.i_req_approval_alert
            UserMailer.accept_extension_request(lender, borrower, @item, params[:result]).deliver_later
          end
          #delete all pre-scheduled job for this item
          SendEmailJob.delete_prev_entries(@item.id)

          #add new due date smart alerts for borrower to the delay queue 
          #email will be sent 1 week before, 3 days before and the day before due date
          duration = ((@borrowed_item.due_date.to_i - Time.now.to_i) / 1.day)
          if @notif.i_due_alert
            if duration-7 > 0
              SendEmailJob.set(wait: (duration-7).days).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
            end
            if duration-3 > 0
              SendEmailJob.set(wait: (duration-3).days).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
            end
            if duration-1 > 0
              SendEmailJob.set(wait: (duration-1).days).perform_later(lender.id, borrower.id, @item.id, "smart_alert")
            end
          end
          #unconditional mailer to be delivered to both lender/borrower on due date
          SendEmailJob.set(wait: duration.days).perform_later(lender.id, borrower.id, @item.id, "Borrower")
          SendEmailJob.set(wait: duration.days).perform_later(lender.id, borrower.id, @item.id, "Lender")
          flash[:success_msg] = "Due date extension request for item [#{@item.name}] has been granted. New due date reminders have been scheduled for [#{borrower.fname}] at your convenience!"
      redirect_to  user_items_path(params[:user_id])
    elsif params[:result] == "denied"
      @borrowed_item.reject_req
      @borrowed_item.save
      #send extension status update to borrower
      if @notif.i_req_approval_alert
        UserMailer.accept_extension_request(lender, borrower, @item, params[:result]).deliver_later
      end
      flash[:success_msg] = "Due date extension request for item [#{@item.name}] has been rejected!"
      redirect_to  user_items_path(params[:user_id])
    end
  end

  def destroy
      @borrowed_item = @user.borrowed_items.find_by_item_id(@item_id)
      @borrowed_item.destroy
  end

  private
   def borrowed_item_params
     params.require(:borrowed_item).permit(:id,:item_id,:user_id, :due_date, :temp_due_date)
   end
end
