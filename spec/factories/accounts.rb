FactoryBot.define do
  factory :account do
    sequence(:provider_account_id) { |n| "provider#{n}" }
    sequence(:reference_code) { |n| "ref#{n}" }
    description { FFaker::Company.name.gsub(/[^#{REGEX_BUSINESS_NAME}]/, '') }
    document_type { 'CPF' }
    document_number { FFaker::IdentificationBR.cpf.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4') }
  end
end
