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

    if @boleto.save
      render json: @boleto, status: :created, location: @boleto
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
    # Use callbacks to share common setup or constraints between actions.
    def set_boleto
      @boleto = Boleto.find_by!(
        account_id: current_account.id,
        id: params[:id]
      )
    end

    # Only allow a list of trusted parameters through.
    def boleto_params
      params.fetch(:boleto, {})
    end
end
