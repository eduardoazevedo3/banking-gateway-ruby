class Contact < ApplicationRecord
  DOCUMENT_TYPES = %w[ CPF CNPJ ].freeze

  belongs_to :account

  validates :full_name, length: { in: 3..255 }
  validates :document_type, inclusion: { in: DOCUMENT_TYPES }
  validates :document_number, format: { with: REGEX_DOCUMENTATION }
  validates :phone, length: { in: 14..15 }, format: { with: REGEX_PHONE_NUMBER }
  validates :zip_code, length: { is: 9 }
  validates :address, length: { in: 3..255 }
  validates :address_number, length: { in: 1..20 }
  validates :city, length: { in: 3..255 }
  validates :neighborhood, length: { in: 3..255 }
  validates :state, length: { is: 2 }, format: { with: REGEX_STATE_CODE }
end
