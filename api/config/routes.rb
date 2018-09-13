Rails.application.routes.draw do
  devise_for :users, only: []

  root controller: :application, action: :check

  get '*path', controller: :application, action: :not_found_error
end
