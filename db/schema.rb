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

ActiveRecord::Schema[8.0].define(version: 2024_12_01_010903) do
  create_table "accounts", charset: "utf8mb4", force: :cascade do |t|
    t.string "provider_account_id"
    t.string "reference_code"
    t.string "description"
    t.string "document_type"
    t.string "document_number"
    t.text "credentials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_account_id", "document_type", "document_number"], name: "idx_accounts_provider_account_document_type_number", unique: true
  end

  create_table "boletos", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "covenant_id", limit: 64, null: false
    t.string "reference_code", limit: 64
    t.string "our_number", limit: 64, null: false
    t.string "status", limit: 50, default: "PENDING", null: false
    t.string "issuing_bank", limit: 50, null: false
    t.json "issue_data", null: false
    t.date "issue_date", null: false
    t.date "due_date", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "discount_amount", precision: 10, scale: 2
    t.decimal "fine_amount", precision: 10, scale: 2
    t.decimal "interest_amount", precision: 10, scale: 2
    t.decimal "fee_amount", precision: 10, scale: 2
    t.integer "protest_days"
    t.integer "negativation_days"
    t.string "negativation_agency"
    t.integer "receipt_days_limit"
    t.string "boleto_type_code"
    t.string "boleto_type_description"
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
    t.datetime "registered_at"
    t.index ["account_id", "covenant_id", "our_number"], name: "index_boletos_on_account_id_and_covenant_id_and_our_number", unique: true
    t.index ["account_id", "reference_code"], name: "index_boletos_on_account_id_and_reference_code", unique: true
    t.index ["account_id"], name: "index_boletos_on_account_id"
  end

  create_table "solid_cache_entries", charset: "utf8mb4", force: :cascade do |t|
    t.binary "key", limit: 1024, null: false
    t.binary "value", size: :long, null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  add_foreign_key "boletos", "accounts"
end
