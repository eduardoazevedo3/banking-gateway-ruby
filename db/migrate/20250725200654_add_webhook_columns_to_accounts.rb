class AddWebhookColumnsToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :webhook_url, :string, after: :issue_data
    add_column :accounts, :webhook_secret, :string, after: :webhook_url
  end
end
