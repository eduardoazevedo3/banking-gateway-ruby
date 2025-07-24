class V1::BoletosController < ApplicationController
  before_action :set_boleto, only: %i[ show update destroy register ]

  def index
    boletos = Boleto.by_reference_code(params[:reference_code])

    limit = params[:limit]&.to_i || 100

    render_formatted_json paginate_with_cursor(boletos, limit:)
  end

  def conciliation
    # TODO: Implement conciliation logic here
    # For now, returns ok status
    render status: 'conciliation_completed'
  end

  def register
    # TODO: Implement register logic here
    # For now, returns the updated boleto
    render_formatted_json @boleto
  end

  def show
    render_formatted_json @boleto
  end

  def create
    @boleto = Boleto.new(boleto_params)
    @boleto.account = current_account

    if @boleto.save
      render_formatted_json @boleto, status: :created
    else
      render_formatted_json @boleto.errors, status: :unprocessable_entity
    end
  end

  def update
    if @boleto.update(boleto_params)
      render_formatted_json @boleto
    else
      render_formatted_json @boleto.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @boleto.destroy!
  end

  private

  def set_boleto
    @boleto = Boleto.find_by!(
      account_id: current_account.id,
      id: params[:id]
    )
  end

  def boleto_params
    params.require(:boleto).permit(
      :covenant_id,
      :reference_code,
      :our_number,
      :issuing_bank,
      :issue_date,
      :due_date,
      :amount,
      :discount_amount,
      :fine_amount,
      :interest_amount,
      :fee_amount,
      :protest_days,
      :negativation_days,
      :negativation_agency,
      :receipt_days_limit,
      :boleto_type_code,
      :boleto_type_description,
      :beneficiary_type,
      :beneficiary_document,
      :beneficiary_name,
      :payer_type,
      :payer_document,
      :payer_name,
      :payer_address,
      :payer_address_number,
      :payer_zip_code,
      :payer_city,
      :payer_neighborhood,
      :payer_state,
      :payer_phone,
      issue_data: {}
    )
  end
end
