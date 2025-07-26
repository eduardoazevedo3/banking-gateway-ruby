class Webhooks::BaseWebhookService < ApplicationService
  def call
    raise NotImplementedError, 'Subclasses must implement this method'
  end

  protected

  attr_reader :account

  def generate_signature(body)
    return if account.webhook_secret.blank?

    OpenSSL::HMAC.hexdigest('SHA256', account.webhook_secret, body)
  end

  def conn
    @conn ||= Faraday.new(
      url: account.webhook_url,
      headers: {
        'Content-Type' => 'application/json'
      }
    )
  end
end
