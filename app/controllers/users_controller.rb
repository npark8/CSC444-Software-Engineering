class UsersController < ApplicationController
skip_before_action :require_login, except: [:index, :indexx, :show, :edit, :update]
	def index
    @users = User.user_search(params[:name])
    if session[:user_id].nil?
      redirect_to login_path
    else
		  @user = User.find(session[:user_id]) #for testing
      #@user = User.find(1)
      @blockee_users = Blockee.blockees_of_user(@user)
      @time = greetings_by_time
    end
	end
  def indexx
    @user = User.find(current_user.id)
    if @user.admin == false
      redirect_to @user
    end 
    @users = User.all

  end
  def checkPrivilege
    if User.find(current_user).admin == true
      return true
    else
      return false
    end
  end
	def show
		@user = User.find(params[:id])
    @logged_in_user = User.find(session[:user_id])
    @notification = Notification.find_by_user_id(@user.id)
    @blockee_users = Blockee.blockees_of_user(@user)
    
    #create notification preference when fb user first login
    if(!@notification)
      Notification.create(:user_id => @user.id);
    end
    @notification = Notification.find_by_user_id(@user.id)

    #public view
    @user_items = Item.where("items.user_id = ? and items.disable = false", @user.id)
    @reviews = ReviewBorrower.joins(:user).select("review_borrowers.*, review_borrowers.rating as r_rating, users.*").where("review_borrowers.borrower_id = ?", @user.id)
    @reviews_by_borrower = ReviewLenderAndItem.joins(:user).select("review_lender_and_items.*, review_lender_and_items.rating as r_rating, users.*").where("review_lender_and_items.lender_id = ?", @user.id)
	end
  def new
    @user = User.new
  end
  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success_msg] = 'Welcome to BoLend! Your account has been verified.'
      redirect_to login_path
    else
      flash[:failure_msg] = 'Error: user does not exist.'
      redirect_to login_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      #UserMailer.with(user: @user).welcome_email.deliver
      Notification.create(:user_id => @user.id);
      flash[:success_msg] = "Registration successful! Please verify your email address."
      redirect_to login_path

    else
      flash[:failure_msg] = "Passwords do not match/Not minimum 6 characters."
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @logged_in_user = User.find(session[:user_id])
  end

  def delete

      @users = User.all
      @users.delete(params[:deleteid])
      @user = User.find(session[:user_id])

      redirect_to @user


  end 

  def update
    @user = User.find(session[:user_id])
    if @user.update_attributes(user_params)
      flash[:success] = "Updated user information"
      redirect_to @user

    else

    end
  end

  def greetings_by_time
    time = Time.now.hour
    if time>6 and time<12
      "Good Morning"
    elsif time>12 and time<17
      "Good Afternoon"
    else
      "Good Evening"
    end
  end

  private def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :fname, :lname, :phonenum, :address)
  end

end
