class Boleto < ApplicationRecord
  BOLETO_STATUS_ENUM = %w[
    PENDING REGISTERING FAILED OPENED
    PAID CANCELED EXPIRED REJECTED
  ].freeze

  NEGATIVATION_AGENCY_ENUM = %w[ SERASA ].freeze
  ISSUING_BANK_ENUM = %w[ BANCO_BRASIL ].freeze
  DOCUMENT_TYPE_ENUM = %w[ CPF CNPJ ].freeze
  BOLETO_TYPE_CODE_ENUM = {
    CHEQUE: '1',
    MERCANTILE_DUPLICATE: '2',
    MERCANTILE_DUPLICATE_BY_INDICATION: '3',
    SERVICE_DUPLICATE: '4',
    SERVICE_DUPLICATE_BY_INDICATION: '5',
    RURAL_DUPLICATE: '6',
    BILL_OF_EXCHANGE: '7',
    COMMERCIAL_CREDIT_NOTE: '8',
    EXPORT_CREDIT_NOTE: '9',
    INDUSTRIAL_CREDIT_NOTE: '10',
    RURAL_CREDIT_NOTE: '11',
    PROMISSORY_NOTE: '12',
    RURAL_PROMISSORY_NOTE: '13',
    MERCANTILE_TRIPLICATE: '14',
    SERVICE_TRIPLICATE: '15',
    INSURANCE_NOTE: '16',
    RECEIPT: '17',
    INVOICE: '18',
    DEBIT_NOTE: '19',
    INSURANCE_POLICY: '20',
    SCHOOL_FEE: '21',
    CONSORTIUM_INSTALLMENT: '22',
    UNION_ACTIVE_DEBT: '23',
    STATE_ACTIVE_DEBT: '24',
    MUNICIPAL_ACTIVE_DEBT: '25',
    CREDIT_CARD: '31',
    PROPOSAL_BOLETO: '32',
    CONTRIBUTION_BOLETO: '33',
    OTHERS: '99'
  }.freeze

  belongs_to :account

  validates :covenant_id, presence: true, length: { maximum: 64 }
  validates :reference_code, length: { maximum: 64 }, format: { with: REGEX_NUMBER_WITH_DOTS }, uniqueness: { scope: :account_id }
  validates :our_number, presence: true, length: { maximum: 64 }, uniqueness: { scope: %i[ covenant_id account_id ] }
  validates :status, presence: true, length: { maximum: 50 }, inclusion: { in: BOLETO_STATUS_ENUM }
  validates :issuing_bank, presence: true, length: { maximum: 50 }, inclusion: { in: ISSUING_BANK_ENUM }
  validates :issue_data, presence: true
  validates :issue_date, presence: true
  validates :due_date, presence: true
  validates :amount, presence: true
  validates :discount_amount, numericality: { allow_nil: true }
  validates :fine_amount, numericality: { allow_nil: true }
  validates :interest_amount, numericality: { allow_nil: true }
  validates :fee_amount, numericality: { allow_nil: true }
  validates :protest_days, numericality: { only_integer: true, greater_than: 0, less_than: 91, allow_nil: true }
  validates :negativation_days, numericality: { only_integer: true, greater_than: 0, less_than: 91, allow_nil: true }
  validates :negativation_agency, allow_nil: true, inclusion: { in: NEGATIVATION_AGENCY_ENUM }
  validates :receipt_days_limit, numericality: { only_integer: true, greater_than: 0, less_than: 91, allow_nil: true }
  validates :boleto_type_code, inclusion: { in: BOLETO_TYPE_CODE_ENUM.values }
  validates :boleto_type_description, length: { maximum: 255 }
  validates :beneficiary_type, presence: true, inclusion: { in: DOCUMENT_TYPE_ENUM }
  validates :beneficiary_document, presence: true, length: { in: 14..18 }
  validates :beneficiary_name, presence: true, length: { in: 3..255 }
  validates :payer_type, inclusion: { in: DOCUMENT_TYPE_ENUM }
  validates :payer_document, presence: true, length: { in: 14..18 }
  validates :payer_name, presence: true, length: { in: 3..255 }
  validates :payer_address, presence: true, length: { in: 3..255 }
  validates :payer_address_number, presence: true, length: { in: 1..20 }
  validates :payer_zip_code, presence: true, length: { in: 9..9 }
  validates :payer_city, presence: true, length: { in: 3..255 }
  validates :payer_neighborhood, presence: true, length: { in: 3..255 }
  validates :payer_state, presence: true, length: { in: 2..2 }
  validates :payer_phone, presence: true, length: { in: 14..15 }
  validates :rejection_reason, length: { maximum: 255 }
  validates :barcode, length: { maximum: 64 }
  validates :digitable_line, length: { maximum: 64 }
  validates :billing_contract_number, length: { maximum: 64 }
end
