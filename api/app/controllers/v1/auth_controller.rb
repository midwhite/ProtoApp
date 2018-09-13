class V1::AuthController < ApplicationController
  skip_before_action :authenticate_user_from_token!

  def twitter
  end

  def twitter_callback
  end

  def google
  end

  def google_callback
  end

  def facebook
    redirect_to User::AuthService.facebook_oauth_endpoint
  end

  def facebook_callback
    user = User::AuthService.find_facebook_user(params[:code])
    redirect_to User::AuthService.app_redirect_uri(user)
  end
end
