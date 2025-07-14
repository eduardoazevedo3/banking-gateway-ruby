class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "ExampleJob executado com argumentos: #{args.inspect}"

    Rails.logger.info "ExampleJob finalizado com sucesso"
  end
end
