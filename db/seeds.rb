# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

100.times do |i|
  Account.create(
    provider_account_id: i,
    description: FFaker::Name.name.gsub(/[^a-zA-ZÀ-ÿ0-9\s]/, ''),
    document_type: "CPF",
    document_number: FFaker::IdentificationBR.cpf.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4')
  )
end
