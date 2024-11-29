class Account < ApplicationRecord
  enum :document_type, { cpf: 'CPF', cnpj: 'CNPJ' }

  validates :provider_account_id, format: { with: REGEX_NUMBER_WITH_DOTS }
  validates :reference_code, format: { with: REGEX_NUMBER_WITH_DOTS }
  validates :description, presence: true, length: { maximum: 255 }, format: { with: REGEX_BUSINESS_NAME }
  validates :document_type, presence: true
  validates :document_number, presence: true, length: { maximum: 18 }, format: { with: REGEX_DOCUMENTATION }

  squishize :description, :document_number

  def as_json
    super except: %i[credentials]
  end
end
