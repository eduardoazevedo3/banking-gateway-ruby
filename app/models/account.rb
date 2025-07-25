class Account < ApplicationRecord
  include DocumentValidate

  DOCUMENT_TYPE_ENUM = %w[ CPF CNPJ ].freeze

  validates :provider_account_id, uniqueness: true
  validates :provider_account_id, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :reference_code, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :description, presence: true, length: { in: 3..255 }, format: { with: REGEX_BUSINESS_NAME }
  validates :document_type, presence: true, length: { maximum: 10 }, inclusion: { in: DOCUMENT_TYPE_ENUM }
  validates :document_number, presence: true, format: { with: REGEX_DOCUMENTATION }
  validates :document_number, length: { is: 14 }, if: -> { document_type == 'CPF' }
  validates :document_number, length: { is: 18 }, if: -> { document_type == 'CNPJ' }
  validates :document_number, uniqueness: { scope: %i[ document_type provider_account_id ] }

  document_validate :document_number

  squishize :description, :document_number

  scope :by_provider_account_id, ->(provider_account_id) do
    where(provider_account_id:) if provider_account_id.present?
  end

  scope :by_reference_code, ->(reference_code) do
    where(reference_code:) if reference_code.present?
  end

  def as_json
    super except: %i[credentials]
  end
end
