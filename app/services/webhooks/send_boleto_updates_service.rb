class Webhooks::SendBoletoUpdatesService < Webhooks::BaseWebhookService
  def initialize(boleto)
    @boleto = boleto
    @account = boleto.account
  end

  def call
    return unless account.webhook_url.present?

    send_boleto_webhook!
  end

  private

  attr_reader :boleto, :account

  def send_boleto_webhook!
    body = { boleto: boleto.as_json }
    signature = generate_signature(body)

    conn.post do |req|
      req.body = body.to_json
      req.headers['X-Signature'] = signature if signature.present?
    end
  rescue StandardError => e
    Rails.logger.error("[SendBoletoWebhookService] Error sending webhook: #{e.message}")
    raise e
  end
end
