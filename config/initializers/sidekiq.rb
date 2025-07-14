require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_QUEUE_URL', 'redis://localhost:6379/0') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_QUEUE_URL', 'redis://localhost:6379/0') }
end

# Configure Sidekiq::Web for CSRF protection
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_banking_gateway_session'
Sidekiq::Web.use ActionDispatch::Flash
