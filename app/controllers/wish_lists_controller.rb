class WishListsController < ApplicationController
  before_action :authenticate_user_before_db_update
	before_action :find_user_set_item_id, only: [:create, :destroy]

	def create
   		@wish_item = @user.wish_lists.create(wish_item_params)
   		if @wish_item.save
        item = Item.find(@wish_item.item_id).name
        flash[:success_msg] = "Item [#{item}] has been added to your wish list!"
      else
        flash[:failure_msg] = "Something went wrong!"
      end
      #set_locals_render_partial
      redirect_to user_items_path(params[:user_id])
	end
	def update
	end
	def destroy
   		@wish_item = @user.wish_lists.find_by_item_id(@item_id)
      item = Item.find(@wish_item.item_id).name
      if(@wish_item.destroy)
        flash[:success_msg] = "Item [#{item}] has been deleted from your wish list!"
      else
        flash[:failure_msg] = "Something went wrong!"
      end
      #set_locals_render_partial
      redirect_to user_items_path(params[:user_id])
	end
	private
 	 def wish_item_params
 		 #puts params.inspect
 		 params.permit(:id,:item_id,:user_id)
 	 end

 	 def find_user_set_item_id
 	 	@user = User.find(params[:user_id])
		@item_id = params[:id]
		if(!@item_id)
			@item_id = params[:item_id]
		end
 	 end

end
