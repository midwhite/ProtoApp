Rails.application.routes.draw do
  devise_for :users, only: []

  root controller: :application, action: :check

  namespace :v1 do
    # Auth
    scope :auth do
      scope :facebook do
        root controller: :auth, action: :facebook, as: :facebook
        get :callback, controller: :auth, action: :facebook_callback, as: :facebook_callback
      end

      scope :google do
        root controller: :auth, action: :google, as: :google
        get :callback, controller: :auth, action: :google_callback, as: :google_callback
      end

      scope :twitter do
        root controller: :auth, action: :twitter, as: :twitter
        get :callback, controller: :auth, action: :twitter_callback, as: :twitter_callback
      end
    end
  end

  get '*path', controller: :application, action: :not_found_error
end
