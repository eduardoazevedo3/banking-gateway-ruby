# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_25_200654) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "provider_account_id", limit: 64
    t.string "reference_code", limit: 64
    t.string "description", null: false
    t.string "document_type", limit: 10, null: false
    t.string "document_number", limit: 50, null: false
    t.text "credentials"
    t.json "issue_data"
    t.string "webhook_url"
    t.string "webhook_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_account_id", "document_type", "document_number"], name: "idx_accounts_provider_account_document_type_number", unique: true
    t.index ["provider_account_id"], name: "idx_accounts_provider_account_id", unique: true
    t.index ["reference_code"], name: "index_accounts_on_reference_code", unique: true
  end

  create_table "boletos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "covenant_id", limit: 64, null: false
    t.string "reference_code", limit: 64
    t.string "our_number", limit: 64, null: false
    t.string "status", limit: 50, default: "PENDING", null: false
    t.string "issuing_bank", limit: 50, null: false
    t.json "issue_data", null: false
    t.date "issue_date", null: false
    t.date "due_date", null: false
    t.date "payment_date"
    t.date "credit_date"
    t.date "discharge_date"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "discount_amount", precision: 10, scale: 2
    t.decimal "fine_amount", precision: 10, scale: 2
    t.decimal "interest_amount", precision: 10, scale: 2
    t.decimal "fee_amount", precision: 10, scale: 2
    t.decimal "received_amount", precision: 10, scale: 2
    t.integer "protest_days"
    t.integer "negativation_days"
    t.string "negativation_agency"
    t.integer "receipt_days_limit"
    t.string "boleto_type_code"
    t.string "boleto_type_description", limit: 50
    t.string "beneficiary_type", null: false
    t.string "beneficiary_document", null: false
    t.string "beneficiary_name", null: false
    t.string "payer_type", null: false
    t.string "payer_document", null: false
    t.string "payer_name", null: false
    t.string "payer_address", null: false
    t.string "payer_address_number", limit: 20, null: false
    t.string "payer_zip_code", null: false
    t.string "payer_city", null: false
    t.string "payer_neighborhood", null: false
    t.string "payer_state", null: false
    t.string "payer_phone", null: false
    t.text "rejection_reason"
    t.string "barcode", limit: 64
    t.string "digitable_line", limit: 64
    t.string "billing_contract_number", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "registered_at"
    t.index ["account_id", "covenant_id", "our_number"], name: "idx_boletos_account_id_covenant_id_our_number", unique: true
    t.index ["account_id", "reference_code"], name: "idx_boletos_account_id_reference_code", unique: true
    t.index ["account_id"], name: "index_boletos_on_account_id"
  end

  add_foreign_key "boletos", "accounts"
end
