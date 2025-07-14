# Configure session store for Sidekiq::Web
Rails.application.config.session_store :cookie_store, key: '_banking_gateway_session'
