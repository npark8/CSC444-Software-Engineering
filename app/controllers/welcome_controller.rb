class WelcomeController < ApplicationController
  skip_before_action :require_login
  def index
    @items = Item.where(disable: false)
  end
end
