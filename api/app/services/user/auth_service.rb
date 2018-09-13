class User::AuthService < ApplicationService
  require "open-uri"

  FACEBOOK_OAUTH_VERSION  = "v3.1"
  FACEBOOK_OAUTH_ENDPOINT = "https://www.facebook.com/dialog/oauth"
  FACEBOOK_TOKEN_ENDPOINT = "https://graph.facebook.com/" + FACEBOOK_OAUTH_VERSION + "/oauth/access_token"
  FACEBOOK_REDIRECT_URI   = API_DOMAIN + "/v1/auth/facebook/callback"

  def self.facebook_oauth_endpoint
    query_hash = {
      client_id: FACEBOOK_APP_ID,
      redirect_uri: FACEBOOK_REDIRECT_URI
    }
    FACEBOOK_OAUTH_ENDPOINT + query_string(query_hash)
  end

  def self.facebook_token_endpoint(code)
    query_hash = {
      client_id: FACEBOOK_APP_ID,
      client_secret: FACEBOOK_APP_SECRET,
      redirect_uri: FACEBOOK_REDIRECT_URI,
      code: code
    }
    FACEBOOK_TOKEN_ENDPOINT + query_string(query_hash)
  end

  def self.app_redirect_uri(user)
    query_hash = { token: user.access_token }
    APP_DOMAIN + "/auth/callback" + query_string(query_hash)
  end

  def self.find_facebook_user(code)
    oauth = JSON.parse(open(self.facebook_token_endpoint(code)).read, symbolize_names: true)
    graph = Koala::Facebook::API.new(oauth[:access_token])

    result = graph.get_object('me?locale=ja_JP&fields=id,name,email,age_range,gender,picture.width(400),friends.limit(100)', local: "en_US").deep_symbolize_keys

    user = User.where(uid: result[:id], provider: "facebook").first_or_initialize
    user.name ||= result[:name]
    user.email = user.email.presence || result[:email] || user.dummy_email
    user.access_token ||= Devise.friendly_token(32)
    user.save!

    user
  end

  private
  def self.query_string(query_hash)
    "?" + query_hash.map{|key, value| "#{key}=#{value}" }.join("&")
  end
end
