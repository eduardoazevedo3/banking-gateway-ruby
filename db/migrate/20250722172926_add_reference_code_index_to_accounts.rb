class AddReferenceCodeIndexToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_index :accounts, :reference_code, unique: true
  end
end
