threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port        ENV.fetch("PORT") { 3000 }

rails_env = ENV.fetch("RAILS_ENV") { "development" }

environment rails_env

if rails_env === "development"
  ssl_bind '0.0.0.0', '9292', {
    key: "#{Rails.root}/config/server.key",
    cert: "#{Rails.root}/config/server.crt",
    verify_mode: "none"
  }
end

plugin :tmp_restart
