class V1::BoletosController < ApplicationController
  before_action :set_boleto, only: %i[ show update destroy ]

  # GET /api/v1/boletos
  def index
    @boletos = Boleto.all

    render json: @boletos
  end

  # GET /api/v1/boletos/1
  def show
    render json: @boleto
  end

  # POST /api/v1/boletos
  def create
    @boleto = Boleto.new(boleto_params)
    @boleto.account = current_account

    if @boleto.save
      render json: @boleto, status: :created
    else
      render json: @boleto.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/boletos/1
  def update
    if @boleto.update(boleto_params)
      render json: @boleto
    else
      render json: @boleto.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/boletos/1
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
