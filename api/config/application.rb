require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProtApp
  class Application < Rails::Application
    config.load_defaults 5.2

    config.time_zone = "Tokyo"

    config.active_storage.service = :amazon

    config.i18n.default_locale = :ja

    config.generators do |generator|
      generator.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: true
    
      # fixtureの代わりにfactory_girlを使うよう設定
      generator.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.api_only = true
  end
end
