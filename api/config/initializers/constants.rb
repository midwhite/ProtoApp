module Constants
  if Rails.env.production?
    APP_DOMAIN = "https://proto-app.com"
    API_DOMAIN = "https://api.proto-app.com"
  else
    APP_DOMAIN = "https://localhost:8080"
    API_DOMAIN = "https://localhost:9292"
  end
end