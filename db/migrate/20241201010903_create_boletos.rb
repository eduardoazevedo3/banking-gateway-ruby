class CreateBoletos < ActiveRecord::Migration[8.0]
  def change
    create_table :boletos do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.string :covenant_id, null: false, limit: 64
      t.string :reference_code, limit: 64
      t.string :our_number, null: false, limit: 64
      t.string :status, null: false, default: 'PENDING', limit: 50
      t.string :issuing_bank, null: false, limit: 50
      t.json :issue_data, null: false
      t.date :issue_date, null: false
      t.date :due_date, null: false
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.decimal :discount_amount, precision: 10, scale: 2
      t.decimal :fine_amount, precision: 10, scale: 2
      t.decimal :interest_amount, precision: 10, scale: 2
      t.decimal :fee_amount, precision: 10, scale: 2
      t.integer :protest_days
      t.integer :negativation_days
      t.string :negativation_agency, limit: 255
      t.integer :receipt_days_limit
      t.string :boleto_type_code, limit: 255
      t.string :boleto_type_description, limit: 255
      t.string :beneficiary_type, null: false, limit: 255
      t.string :beneficiary_document, null: false, limit: 255
      t.string :beneficiary_name, null: false, limit: 255
      t.string :payer_type, null: false, limit: 255
      t.string :payer_document, null: false, limit: 255
      t.string :payer_name, null: false, limit: 255
      t.string :payer_address, null: false, limit: 255
      t.string :payer_address_number, null: false, limit: 20
      t.string :payer_zip_code, null: false, limit: 255
      t.string :payer_city, null: false, limit: 255
      t.string :payer_neighborhood, null: false, limit: 255
      t.string :payer_state, null: false, limit: 255
      t.string :payer_phone, null: false, limit: 255
      t.text :rejection_reason
      t.string :barcode, limit: 64
      t.string :digitable_line, limit: 64
      t.string :billing_contract_number, limit: 64
      t.datetime :registered_at

      t.index %i[ account_id covenant_id our_number ], unique: true
      t.index %i[ account_id reference_code ], unique: true
    end
  end
end
