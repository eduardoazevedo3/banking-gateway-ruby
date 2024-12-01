require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BankingGatewayRuby
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Timezone and locale configuration
    config.time_zone = 'Brasilia'
    config.i18n.default_locale = 'pt-BR'

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    config.api_only = true

    # Rails generate files
    config.generators do |g|
      g.test_framework nil
      g.helper false
      g.system_tests false
      g.jbuilder false
      g.assets false
      g.decorator false
    end

    # CSP configuration
    config.action_dispatch.default_headers.merge!({
      'X-Frame-Options' => 'DENY',
      'X-XSS-Protection' => '1; mode=block'
    })

    # Load extra directories
    # config.autoload_paths << config.root.join('app/services')
  end
end
