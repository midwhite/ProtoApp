class V1::AuthController < ApplicationController
  skip_before_action :authenticate_user_from_token!
  before_action :login_if_token_exists!, only: [:me]

  def me
    render json: { me: current_user && current_user.me }
  end

  def facebook
    redirect_to User::AuthService.facebook_oauth_endpoint
  end

  def facebook_callback
    user = User::AuthService.find_facebook_user(params[:code])
    redirect_to User::AuthService.app_redirect_uri(user)
  end

  def google
    redirect_to User::AuthService.google_oauth_endpoint
  end

  def google_callback
    user = User::AuthService.find_google_user(params[:code])
    redirect_to User::AuthService.app_redirect_uri(user)
  end

  def twitter
    redirect_to User::AuthService.twitter_oauth_endpoint
  end

  def twitter_callback
    user = User::AuthService.find_twitter_user(params[:oauth_token], params[:oauth_verifier])
    redirect_to User::AuthService.app_redirect_uri(user)
  end
end
