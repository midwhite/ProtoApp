module Constants
  if Rails.env.production?
    APP_DOMAIN = "https://proto-app.com"
    API_DOMAIN = "https://api.proto-app.com"
  else
    APP_DOMAIN = "https://localhost:8080"
    API_DOMAIN = "https://localhost:9292"
  end

  INFO_EMAIL = "info@proto-app.com"

  FACEBOOK_APP_ID = ENV.fetch("FACEBOOK_APP_ID")
  FACEBOOK_APP_SECRET = ENV.fetch("FACEBOOK_APP_SECRET")

  TMP_PHOTOS_DIR = "tmp"
end
