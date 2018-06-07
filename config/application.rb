require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PocketMoneyApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.beginning_of_week = :sunday

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:3000/'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end

    # Rails 3/4

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins localhost
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  end
end
