require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:valid_attributes) do
    {
      provider_account_id: 'provider-123',
      reference_code: 'REF-001',
      description: 'Valid Business',
      document_type: 'CPF',
      document_number: '390.533.447-05' # valid, formatted CPF for test
    }
  end

  it 'is valid with valid attributes' do
    account = Account.new(valid_attributes)
    expect(account).to be_valid
  end

  it 'is invalid without a description' do
    attrs = valid_attributes.merge(description: nil)
    account = Account.new(attrs)
    expect(account).not_to be_valid
    expect(account.errors[:description]).to include("can't be blank")
  end
end
