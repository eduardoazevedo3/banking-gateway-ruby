class V1::AccountSerializer
  def initialize(account)
    @account = account
  end

  def as_json
    {}
  end

  private

  attr_reader :account
end
