class Account < ApplicationRecord
  DOCUMENT_TYPE_ENUM = %w[ CPF CNPJ ].freeze

  validates :provider_account_id, uniqueness: true
  validates :provider_account_id, uniqueness: { scope: %i[ document_type document_number ] }
  validates :provider_account_id, presence: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :reference_code, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :description, presence: true, length: { in: 3..255 }, format: { with: REGEX_BUSINESS_NAME }
  validates :document_type, presence: true, length: { maximum: 10 }, inclusion: { in: DOCUMENT_TYPE_ENUM }
  validates :document_number, presence: true, length: { in: 14..18 }, format: { with: REGEX_DOCUMENTATION }

  squishize :description, :document_number

  def as_json
    super except: %i[credentials]
  end
end
