class Boleto < ApplicationRecord
  include DocumentValidate

  NEGATIVATION_AGENCIES = %w[ SERASA ].freeze
  ISSUING_BANKS = %w[ BANCO_BRASIL ].freeze
  DOCUMENT_TYPES = %w[ CPF CNPJ ].freeze
  BOLETO_TYPE_CODES = {
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

  enum :status, {
    pending: 'PENDING',
    registering: 'REGISTERING',
    failed: 'FAILED',
    opened: 'OPENED',
    paid: 'PAID',
    canceled: 'CANCELED',
    expired: 'EXPIRED'
  }

  belongs_to :account

  validates :covenant_id, presence: true, length: { maximum: 64 }, format: { with: REGEX_ALPHANUMERIC_WITH_DOTS }
  validates :reference_code, allow_nil: true, length: { maximum: 64 }, format: { with: REGEX_REFERENCE_CODE }
  validates :reference_code, uniqueness: { scope: :account_id }, if: -> { reference_code.present? }
  validates :our_number, presence: true, length: { maximum: 64 }, format: { with: REGEX_NUMBERS_ONLY }
  validates :our_number, uniqueness: { scope: %i[ covenant_id account_id ] }, if: -> { our_number.present? }
  validates :issuing_bank, presence: true, length: { maximum: 50 }, inclusion: { in: ISSUING_BANKS }
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
  validates :negativation_agency, allow_nil: true, inclusion: { in: NEGATIVATION_AGENCIES }
  validates :receipt_days_limit, numericality: { only_integer: true, greater_than: 0, less_than: 91, allow_nil: true }
  validates :boleto_type_code, allow_nil: true, inclusion: { in: BOLETO_TYPE_CODES.values }
  validates :boleto_type_description, allow_nil: true, length: { maximum: 50 }
  validates :beneficiary_type, presence: true, inclusion: { in: DOCUMENT_TYPES }
  validates :beneficiary_document, presence: true, format: { with: REGEX_DOCUMENTATION }
  validates :beneficiary_document, length: { is: 14 }, if: -> { beneficiary_type == 'CPF' }
  validates :beneficiary_document, length: { is: 18 }, if: -> { beneficiary_type == 'CNPJ' }
  validates :beneficiary_name, presence: true, length: { in: 3..255 }, format: { with: REGEX_BUSINESS_NAME }
  validates :payer_type, presence: true, inclusion: { in: DOCUMENT_TYPES }
  validates :payer_document, presence: true, format: { with: REGEX_DOCUMENTATION }
  validates :payer_document, length: { is: 14 }, if: -> { payer_type == 'CPF' }
  validates :payer_document, length: { is: 18 }, if: -> { payer_type == 'CNPJ' }
  validates :payer_name, presence: true, length: { in: 3..255 }, format: { with: REGEX_BUSINESS_NAME }
  validates :payer_address, presence: true, length: { in: 3..255 }
  validates :payer_address_number, presence: true, length: { in: 1..20 }
  validates :payer_zip_code, presence: true, length: { in: 9..9 }
  validates :payer_city, presence: true, length: { in: 3..255 }
  validates :payer_neighborhood, presence: true, length: { in: 3..255 }
  validates :payer_state, presence: true, length: { in: 2..2 }, format: { with: REGEX_STATE_CODE }
  validates :payer_phone, presence: true, length: { in: 14..15 }, format: { with: REGEX_PHONE_NUMBER }
  validates :received_amount, numericality: { allow_nil: true }
  validates :rejection_reason, length: { maximum: 65535 }
  validates :barcode, length: { maximum: 64 }
  validates :digitable_line, length: { maximum: 64 }
  validates :billing_contract_number, length: { maximum: 64 }

  document_validate :beneficiary_document, :payer_document

  after_commit :send_boleto_webhook, on: %i[ create update ]

  add_scope :by_reference_code do |reference_code|
    where(reference_code:) if reference_code.present?
  end

  private

  def send_boleto_webhook
    SendBoletoWebhookJob.perform_later(id)
  end
end
