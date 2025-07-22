class Account < ApplicationRecord
  DOCUMENT_TYPE_ENUM = %w[ CPF CNPJ ].freeze

  validates :provider_account_id, uniqueness: true
  validates :provider_account_id, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :reference_code, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :description, presence: true, length: { in: 3..255 }, format: { with: REGEX_BUSINESS_NAME }
  validates :document_type, presence: true, length: { maximum: 10 }, inclusion: { in: DOCUMENT_TYPE_ENUM }
  validates :document_number, presence: true, format: { with: REGEX_DOCUMENTATION }
  validates :document_number, uniqueness: { scope: %i[ document_type provider_account_id ] }

  validate :check_document_number_length

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

  private

  def check_document_number_length
    return if document_number.blank?
    return if [ 14, 18 ].include?(document_number.length)

    errors.add(:document_number, :document_number_length)
  end
end
