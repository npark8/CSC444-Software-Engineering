class FriendshipsController < ApplicationController
  def create
    #render plain: params[:friend_requirer].inspect
    @friend_requirer = User.find(params[:friend_requirer])
    @friend_requiree = User.find(params[:friend_requiree])
    @friend_requirer.friend_request(@friend_requiree)
    UserMailer.new_friend_request(@friend_requirer,@friend_requiree).deliver_later
    @user = @friend_requirer
    @users = User.user_search(params[:name])
    
    @blockee_users = Blockee.blockees_of_user(@user)
    
    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  def update
    @user = User.find(params[:friend_requiree])
    @requirer = User.find(params[:friend_requirer])
    if params[:decision]=="true"
      @user.accept_request(@requirer)
      UserMailer.accept_friend_request(@requirer,@user).deliver_later
    elsif params[:decision]=="false"
      @user.decline_request(@requirer)
    else
      @user.block_friend(@requirer)
      @blockee = @user.blockees.create(blockee_params)    
    end
    
    @blockee_users = Blockee.blockees_of_user(@user)
    
    respond_to do |format|
        format.js {render :content_type => 'text/javascript'} 
    end
  end
  
  def destroy
    @friend_remover = User.find(params[:friend_remover])
    @friend_removee = User.find(params[:friend_removee])
    @decision = params[:decision]
    @user = @friend_remover
    if @decision=="unfriend"
      @friend_remover.remove_friend(@friend_removee)
    elsif @decision=="block"
      @friend_remover.block_friend(@friend_removee)
      @blockee = @user.blockees.create(blockee_params)  
    else
      @friend_remover.unblock_friend(@friend_removee)
      @blockee = @user.blockees.find_by(blockee_id: params[:blockee_id])
      @blockee.destroy
    end
    
    @blockee_users = Blockee.blockees_of_user(@user)
    
    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end
  
  private
      def blockee_params
        params.permit(:blockee_id)
      end
end
