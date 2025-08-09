class Account < ApplicationRecord
  include DocumentValidate

  DOCUMENT_TYPE_ENUM = %w[ CPF CNPJ ].freeze

  has_many :boletos, dependent: :restrict_with_error
  has_many :contacts, dependent: :restrict_with_error

  validates :provider_account_id, uniqueness: true
  validates :provider_account_id, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :reference_code, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :description, presence: true, length: { in: 3..255 }, format: { with: REGEX_BUSINESS_NAME }
  validates :document_type, presence: true, length: { maximum: 10 }, inclusion: { in: DOCUMENT_TYPE_ENUM }
  validates :document_number, presence: true, format: { with: REGEX_DOCUMENTATION }
  validates :document_number, length: { is: 14 }, if: -> { document_type == 'CPF' }
  validates :document_number, length: { is: 18 }, if: -> { document_type == 'CNPJ' }
  validates :document_number, uniqueness: { scope: %i[ document_type provider_account_id ] }
  validates :webhook_url, allow_nil: true, length: { maximum: 255 }, format: { with: REGEX_URL }
  validates :webhook_secret, allow_nil: true, length: { minimum: 8, maximum: 255 }

  document_validate :document_number

  squishize :description, :document_number

  add_scope :by_provider_account_id do |provider_account_id|
    where(provider_account_id:) if provider_account_id.present?
  end

  add_scope :by_reference_code do |reference_code|
    where(reference_code:) if reference_code.present?
  end

  def as_json
    super except: %i[credentials webhook_secret]
  end
end
