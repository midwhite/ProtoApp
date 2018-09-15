class User::AuthService < ApplicationService
  require "google/apis/oauth2_v2"
  require "google/api_client/client_secrets"
  require "open-uri"

  FACEBOOK_OAUTH_VERSION  = "v3.1"
  FACEBOOK_OAUTH_ENDPOINT = "https://www.facebook.com/dialog/oauth"
  FACEBOOK_TOKEN_ENDPOINT = "https://graph.facebook.com/" + FACEBOOK_OAUTH_VERSION + "/oauth/access_token"
  FACEBOOK_REDIRECT_URI   = API_DOMAIN + "/v1/auth/facebook/callback"

  GOOGLE_PROJECT_ID     = ENV["GOOGLE_PROJECT_ID"]
  GOOGLE_CALLBACK_URL   = API_DOMAIN + "/v1/auth/google/callback"
  GOOGLE_AUTH_ENDPOINT  = "https://accounts.google.com/o/oauth2/auth"
  GOOGLE_TOKEN_ENDPOINT = "https://accounts.google.com/o/oauth2/token"
  GOOGLE_CERT_ENDPOINT  = "https://www.googleapis.com/oauth2/v1/certs"
  GOOGLE_CLIENT_ID      = ENV["GOOGLE_CLIENT_ID"]
  GOOGLE_CLIENT_SECRET  = ENV["GOOGLE_CLIENT_SECRET"]

  TWITTER_OAUTH_ENDPOINT     = "https://api.twitter.com/oauth/authenticate"
  TWITTER_REQ_TOKEN_ENDPOINT = "https://api.twitter.com/oauth/request_token"
  TWITTER_TOKEN_ENDPOINT     = "https://api.twitter.com/oauth/access_token"
  TWITTER_CALLBACK_URL       = API_DOMAIN + "/v1/auth/twitter/callback"
  TWITTER_CONSUMER_KEY       = ENV["TWITTER_CONSUMER_KEY"]
  TWITTER_CONSUMER_SECRET    = ENV["TWITTER_CONSUMER_SECRET"]

  def self.app_redirect_uri(user)
    query_hash = { token: "#{user.id}:#{user.access_token}" }
    APP_DOMAIN + "/auth/callback" + query_string(query_hash)
  end

  # Facebook OAuth
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

  def self.find_facebook_user(code)
    oauth = JSON.parse(open(self.facebook_token_endpoint(code)).read, symbolize_names: true)
    graph = Koala::Facebook::API.new(oauth[:access_token])

    result = graph.get_object("me?locale=ja_JP&fields=id,name,email,age_range,gender,picture.width(400),friends.limit(100)", local: "en_US").deep_symbolize_keys

    user = User.where(uid: result[:id], provider: "facebook").first_or_initialize
    user.name ||= result[:name]
    user.email = user.email.presence || result[:email] || user.dummy_email
    # user.picture ||= photo_url = oauth.dig(:picture, :data, :url)
    user.save!

    user
  end

  # Google OAuth
  def self.google_oauth_endpoint
    query_hash = {
      client_id: GOOGLE_CLIENT_ID,
      response_type: "code",
      scope: "email%20profile",
      redirect_uri: URI.encode(GOOGLE_CALLBACK_URL),
      state_token: Time.now.to_i
    }
    GOOGLE_AUTH_ENDPOINT + query_string(query_hash)
  end

  def self.find_google_user(code)
    secrets = {
      web: {
        client_id: GOOGLE_CLIENT_ID,
        project_id: GOOGLE_PROJECT_ID,
        auth_uri: GOOGLE_AUTH_ENDPOINT,
        token_uri: GOOGLE_TOKEN_ENDPOINT,
        auth_provider_x509_cert_url: GOOGLE_CERT_ENDPOINT,
        client_secret: GOOGLE_CLIENT_SECRET
      }
    }

    client_secrets = Google::APIClient::ClientSecrets.new(secrets)
    auth_client = client_secrets.to_authorization
    auth_client.update!(scope: ["https://www.googleapis.com/auth/userinfo.profile"])
    auth_client.code = code
    auth_client.grant_type = "authorization_code"
    auth_client.redirect_uri = GOOGLE_CALLBACK_URL
    oauth2 = Google::Apis::Oauth2V2::Oauth2Service.new
    response = oauth2.get_userinfo_v2(options: { authorization: auth_client })

    user = User.where(uid: response.id, provider: "google").first_or_initialize

    user.email = response.email if user.email.blank?
    user.name  = response.name  if user.name.blank?
    # user.picture ||= oauth.picture
    user.save!

    user
  end

  # Twitter OAuth
  def self.twitter_oauth_endpoint
    query_hash = { oauth_token: twitter_request_token[:oauth_token] }
    TWITTER_OAUTH_ENDPOINT + query_string(query_hash)
  end

  def self.find_twitter_user(oauth_token, oauth_verifier)
    oauth = self.twitter_access_token(oauth_token, oauth_verifier)
    user = User.where(uid: oauth[:user_id], provider: "twitter").first_or_create
    user.email = user.dummy_email if user.email.blank?
    user.save!
    user
  end

  private
  def self.query_string(query_hash)
    "?" + query_hash.map{|key, value| "#{key}=#{value}" }.join("&")
  end

  def self.twitter_request_token
    body = {
      oauth_callback: TWITTER_CALLBACK_URL,
      oauth_consumer_key: TWITTER_CONSUMER_KEY,
      oauth_nonce: SecureRandom.uuid,
      oauth_signature_method: "HMAC-SHA1",
      oauth_timestamp: Time.now.to_i,
      oauth_version: "1.0"
    }
    signature_key = TWITTER_CONSUMER_SECRET + "&"
    request_oauth_header = sort_and_concat(body, "&")
    signature_data = "POST&#{ERB::Util.url_encode(TWITTER_REQ_TOKEN_ENDPOINT)}&#{ERB::Util.url_encode(request_oauth_header)}"
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, signature_key, signature_data)
    body[:oauth_signature] = ERB::Util.url_encode(Base64.strict_encode64(hash))
    header_params = sort_and_concat(body, ",")

    twitter_uri = URI.parse(TWITTER_REQ_TOKEN_ENDPOINT)
    https = Net::HTTP.new(twitter_uri.host, twitter_uri.port)
    https.use_ssl = true
    https.verify_mode =  OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(twitter_uri)
    req["Authorization"] = "OAuth #{header_params}"
    res = https.request(req)

    if res.code.to_i >= 400
      raise "AuthService: #{res.body}"
    end

    return res.body.split("&").map{|pair| pair.split("=") }.to_h.symbolize_keys
  end

  def self.twitter_access_token(oauth_token, oauth_verifier)
    # [参考] https://qiita.com/take2isk/items/95f44c107e32c892ac9b
    body = {
      oauth_consumer_key: TWITTER_CONSUMER_KEY,
      oauth_nonce: SecureRandom.uuid,
      oauth_signature_method: "HMAC-SHA1",
      oauth_timestamp: Time.now.to_i,
      oauth_token: oauth_token,
      oauth_verifier: oauth_verifier,
      oauth_version: "1.0"
    }
    signature_key = TWITTER_CONSUMER_SECRET + "&"
    request_oauth_header = sort_and_concat(body, "&")
    signature_data = "POST&#{ERB::Util.url_encode(TWITTER_TOKEN_ENDPOINT)}&#{ERB::Util.url_encode(request_oauth_header)}"
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, signature_key, signature_data)
    signature = ERB::Util.url_encode(Base64.strict_encode64(hash))
    body["oauth_signature"] = signature
    header_params = sort_and_concat(body, ",")
    twitter_uri = URI.parse(TWITTER_TOKEN_ENDPOINT)
    https = Net::HTTP.new(twitter_uri.host, twitter_uri.port)
    https.use_ssl = true
    https.verify_mode =  OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(twitter_uri)
    req["Authorization"] = "OAuth #{header_params}"
    https.set_debug_output $stderr
    res = https.request(req)
    param_hash = {}
    if res.code == "200"
      res.body.split("&").each do |e|
        param = e.split("=")
        param_hash[param[0]] = param[1]
      end
    else
      param_hash["error_message"] = res.body
    end
    return param_hash.symbolize_keys
  end

  def self.sort_and_concat(hash, delimiter)
    hash.map{|k, v| "#{k}=#{v}"}.join(delimiter)
  end
end
