class Contact < ApplicationRecord
  include DocumentValidate

  DOCUMENT_TYPES = %w[ CPF CNPJ ].freeze

  belongs_to :account

  validates :full_name, length: { in: 3..255 }
  validates :document_type, inclusion: { in: DOCUMENT_TYPES }
  validates :document_number, format: { with: REGEX_DOCUMENTATION }
  validates :document_number, length: { is: 14 }, if: -> { document_type == 'CPF' }
  validates :document_number, length: { is: 18 }, if: -> { document_type == 'CNPJ' }
  validates :phone, length: { in: 14..15 }, format: { with: REGEX_PHONE_NUMBER }
  validates :zip_code, length: { is: 9 }
  validates :address, length: { in: 3..255 }
  validates :address_number, length: { in: 1..20 }
  validates :city, length: { in: 3..255 }
  validates :neighborhood, length: { in: 3..255 }
  validates :state, length: { is: 2 }, format: { with: REGEX_STATE_CODE }

  document_validate :document_number

  add_scope :by_reference_code do |reference_code|
    where(reference_code:) if reference_code.present?
  end
end
