class V1::AccountsController < ApplicationController
  before_action :set_account, only: %i[ show update destroy ]

  def index
    accounts = Account
      .by_provider_account_id(params[:provider_account_id])
      .by_reference_code(params[:reference_code])

    limit = params[:limit]&.to_i || 100

    render_formatted_json paginate_with_cursor(accounts, limit:)
  end

  def show
    render_formatted_json account: @account
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      render_formatted_json account: @account, status: :created
    else
      render_validation_error_json @account
    end
  end

  def update
    if @account.update(account_params)
      render_formatted_json account: @account
    else
      render_validation_error_json @account
    end
  end

  def destroy
    @account.destroy!
    head :no_content
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(
      :provider_account_id,
      :reference_code,
      :description,
      :document_type,
      :document_number,
      :credentials,
      :webhook_url,
      :webhook_secret
    )
  end
end
