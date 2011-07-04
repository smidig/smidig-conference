SmidigConference::Application.routes.draw do
  resources :feedback_votes
  resources :feedbacks
  resources :payment_notifications
  resources :contents do
      resources :content_revisions
  end

  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#logout', :as => :logout
  match 'register' => 'users#create', :as => :register
  match 'chat' => 'users#chat', :as => :chat
  match 'users/registration_complete' => 'users#current', :as => 'registration_complete'
  match 'users/current/attending_dinner' => 'users#attending_dinner', :as => :attending_dinner
  match 'users/current/not_attending_dinner' => 'users#not_attending_dinner', :as => :not_attending_dinner
  resources :user_sessions
  resources :password_resets
  resources :users do
    collection do
      get :current
    end
  end

  resources :periods do
    collection do
  post :make_program
  end
  
  
  end

  resources :votes
  resources :comments
  resources :nametags
  resources :talks do
    resources :comments
    resources :votes
  end

  namespace :statistics do
      resources :users_by_company
      resources :all_speakers_by_company
      resources :all_accepted_speakers_by_company
  end

  resources :message_deliveries
  resources :messages
  resources :registrations do
    collection do
      get :phone_list
    end
  end

  resources :acceptances
  resources :tags
  resources :topics do
      resources :talks
  end

  match '/' => 'info#index', :as => 'root'
  match ':controller/:action.:format' => '#index'
  match ':controller.:format' => '#index'
  match '/:controller(/:action(/:id))'
end
