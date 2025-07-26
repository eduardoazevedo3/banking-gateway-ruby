class SendBoletoWebhookJob < ApplicationJob
  queue_as :default

  def perform(boleto_id)
    boleto = Boleto.find(boleto_id)

    Webhooks::SendBoletoUpdatesService.call(boleto)
  end
end
