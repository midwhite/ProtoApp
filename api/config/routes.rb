Rails.application.routes.draw do
  devise_for :users
  root controller: :application, action: :check
end
