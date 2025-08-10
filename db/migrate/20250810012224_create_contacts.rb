class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.references :account, null: false, foreign_key: true
      t.string :reference_code
      t.string :full_name, null: false
      t.string :document_type, null: false
      t.string :document_number, null: false
      t.string :email
      t.string :phone
      t.string :zip_code
      t.string :address
      t.string :address_number
      t.string :city
      t.string :neighborhood
      t.string :state

      t.timestamps

      t.index %i[ account_id reference_code ], unique: true
    end
  end
end
