class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :provider_account_id, limit: 64
      t.string :reference_code, limit: 64
      t.string :description, null: false, limit: 255
      t.string :document_type, null: false, limit: 10
      t.string :document_number, null: false, limit: 50
      t.text :credentials
      t.json :issue_data

      t.timestamps

      t.index :provider_account_id, unique: true, name: 'idx_accounts_provider_account_id'
      t.index %i[provider_account_id document_type document_number], unique: true, name: 'idx_accounts_provider_account_document_type_number'
    end
  end
end
