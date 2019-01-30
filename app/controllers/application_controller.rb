class ApplicationController < ActionController::Base
before_action :require_login
helper_method :current_user
helper_method :authenticate_user_before_db_update
  def current_user
  	#change after adding session
  	User.find_by(id: session[:user_id])
    #User.find(2)
  end
  def current_user2
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def user_signed_in?
    # converts current_user to a boolean by negating the negation
    !!current_user2
  end

  def authenticate_user_before_db_update
    @auth_user ||= User.find(params[:user_id]) if params[:user_id]
    if current_user.admin == true
      return 
    end 
    if @auth_user
      #puts "params user_id : #{params[:user_id]}@@@@@@@@@@@@@@@@"
      if @auth_user != current_user
        #puts "not the same!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        flash[:alert] = "Invalid request: unauthorized user"
        redirect_to user_items_path(session[:user_id])
      else
        #puts "authorized !!!!!!!!!!!!!!!!!!!!!!!!!!"
        #forward message
        flash.now[:success_message] = flash[:success_message] if flash[:success_message]
        flash.now[:failure_message] = flash[:failure_message] if flash[:failure_message]
        return
      end
    else
      #puts "no user_id to perform!!!!!!!!!!!!!!!"
      flash[:alert] = "Invalid request: unauthorized user"  
      redirect_to items
    end
  end
    
  private
    def require_login
      unless current_user
        redirect_to login_url
      end
    end
end
