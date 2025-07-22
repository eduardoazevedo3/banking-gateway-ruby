class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Execute something later
    puts 'Running example job'
  end
end
