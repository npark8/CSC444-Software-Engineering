class ReviewLenderAndItemsController < ApplicationController
before_action :authenticate_user_before_db_update, except: [:show]

def new
	@user = User.find(params[:user_id])
    @item = Item.find(params[:item_id])
    @review_lender = ReviewLenderAndItem.new
end

def create
	  @user = User.find(params[:review_lender_and_item][:user_id])
    @item = Item.find(params[:review_lender_and_item][:item_id])
    @review_lender = @user.review_lender_and_items.create(review_params)
    @lender_id = params[:review_lender_and_item][:lender_id]
    if @review_lender.save
      flash[:success_msg] = "Review successfully saved!"
      @item.returned

      @borrowed_item = @user.borrowed_items.find_by_item_id(@item.id)
      @borrowed_item.set_returned_date
      ItemTransaction.create( :user_id => @user.id, :item_id => @item.id, :returned_on => @borrowed_item.returned_on, :due_date => @borrowed_item.due_date, :user_status => 'Borrower', :other_user_id => @lender_id, :review_lender_and_item_id => @review_lender.id)      

      lender = User.find(@item.user_id)
      #send return confirmation email to borrower
      UserMailer.confirm_return(lender, @item).deliver_later     

      redirect_to user_items_path(@user)
    else
      flash[:failure_msg] = "Information did not meet requirements"
      render :new
    end
end

def show
	@user = User.find(params[:user_id])
	@item = Item.find(params[:id])
  @review_lender = ReviewLenderAndItem.find(params[:review_id])
end

private
def review_params
	params.require(:review_lender_and_item).permit(:user_id, :item_id, :lender_id, :rating, :comment);
end
def set_user_item_ids
	@user = User.find(params[:user_id])
    @item = Item.find(params[:item_id])
end
end
