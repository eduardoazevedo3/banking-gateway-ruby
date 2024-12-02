class Account < ApplicationRecord
  DOCUMENT_TYPE_ENUM = %w[ CPF CNPJ ].freeze

  validates :provider_account_id, uniqueness: { scope: %i[ document_type document_number ] }
  validates :provider_account_id, allow_nil: true, format: { with: REGEX_NUMBER_WITH_DOTS }
  validates :reference_code, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_NUMBER_WITH_DOTS }
  validates :description, presence: true, length: { maximum: 255 }, format: { with: REGEX_BUSINESS_NAME }
  validates :document_type, presence: true, inclusion: { in: DOCUMENT_TYPE_ENUM }
  validates :document_number, presence: true, length: { maximum: 18 }, format: { with: REGEX_DOCUMENTATION }

  squishize :description, :document_number

  def as_json
    super except: %i[credentials]
  end
end
