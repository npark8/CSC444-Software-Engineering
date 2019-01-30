Rails.application.routes.draw do
  #fixes email linkes/sidekiq host error
  #default_url_options :host => "localhost:3000"
  #default_url_options :host => "acupofsugar.herokuapp.com"

  #monitoring scheduled mailer queue
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'admin/index'
  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/indexx'
  get 'users/new'
  get 'users/delete'
  get 'items/index'
  get 'items/itemsindexx'
  resources :items do
   collection do
      get :search, :as => :search
   end
end
  resources :password_resets
  resources :report_users
  resources :users do
  	resources :items do
      put 'lent_out'
      put 'delete_item'
    end
  	resources :on_hold_items do
      put 'update_request_status'
    end
  	resources :wish_lists
    resources :friendships
    resources :borrowed_items do
      put 'update_ext_status'
    end
    resources :lend_items
    resources :review_lender_and_items
    resources :review_borrowers
    resources :notifications
    member do
      get :confirm_email
    end
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end
    Rails.application.routes.draw do
  get 'auth/failure', to: redirect('/')
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/facebook', to: 'sessions#create'

end



  #save for later use, redirect user to /profile page rather than /user/:id - by jiehao
  #get 'profile', to: 'users#show'

  resources :conversations do
  resources :messages
 end


end
