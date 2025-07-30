class Webhooks::BaseWebhookService < ApplicationService
  def call
    raise NotImplementedError, 'Subclasses must implement this method'
  end

  protected

  attr_reader :account

  def generate_signature(body)
    return if account.webhook_secret.blank?

    json = body.is_a?(Hash) ? body.to_json : body
    OpenSSL::HMAC.hexdigest('SHA256', account.webhook_secret, json)
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
