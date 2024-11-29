class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :provider_account_id
      t.string :reference_code
      t.string :description
      t.string :document_type
      t.string :document_number
      t.text :credentials
      t.timestamps

      t.index %i[provider_account_id document_type document_number], unique: true, name: 'idx_accounts_provider_account_document_type_number'
    end
  end
end
