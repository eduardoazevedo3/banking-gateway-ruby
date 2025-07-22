require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { build(:account) }

  it 'is valid with valid attributes' do
    expect(account).to be_valid
  end

  it 'is invalid without a description' do
    account.description = nil

    expect(account).not_to be_valid
    expect(account.errors[:description]).to include("can't be blank")
  end
end
