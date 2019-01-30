class ReviewBorrowersController < ApplicationController
  before_action :authenticate_user_before_db_update, except: [:index, :show]
def index
    @user = User.find(params[:user_id]);
    @reviews = ReviewBorrower.joins(:user).select("review_borrowers.*, review_borrowers.rating as r_rating, users.*").where("review_borrowers.borrower_id = ?", @user.id)
    @reviews_by_borrower = ReviewLenderAndItem.joins(:user).select("review_lender_and_items.*, review_lender_and_items.rating as r_rating, users.*").where("review_lender_and_items.lender_id = ?", @user.id)
end
def new
	@user = User.find(params[:user_id])
    @item = Item.find(params[:item_id])
    @borrower = User.find(params[:borrower_id])
    @review_borrower = ReviewBorrower.new
end

def create
	@user = User.find(params[:review_borrower][:user_id])
    @item = Item.find(params[:review_borrower][:item_id])
    @borrower_id = params[:review_borrower][:borrower_id]
    @review_borrower = @user.review_borrowers.create(review_params)
    if @review_borrower.save
      flash[:success_msg] = "Review successfully saved!"
      @item.available
      @on_hold_item = OnHoldItem.find_by_item_id(@item.id)
      @borrowed_item = BorrowedItem.find_by_item_id(@item.id)
      
      #create transaction entry
      ItemTransaction.create(:user_id => @user.id, :item_id => @item.id, :returned_on => @borrowed_item.returned_on, :due_date => @borrowed_item.due_date, :user_status => 'Lender' , :other_user_id => @borrower_id, :review_borrower_id => @review_borrower.id)
      
      borrower = User.find(@borrowed_item.user_id)
      #send return confirmation email to borrower
      UserMailer.confirm_return(borrower, @item).deliver_later        

        #clear on_hold_item & borrowed_item entries
       @on_hold_item.destroy
       @borrowed_item.destroy
      redirect_to user_items_path(@user)
    else
      flash[:failure_msg] = "Information did not meet requirements"
      render :new
    end
end

def show
	@user = User.find(params[:user_id])
	@item = Item.find(params[:id])
  @review_borrower = ReviewBorrower.find(params[:review_id])
end

private
def review_params
	params.require(:review_borrower).permit(:user_id, :item_id, :borrower_id, :rating, :comment);
end
end
