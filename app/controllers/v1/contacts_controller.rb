class V1::ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show update destroy ]

  def index
    contacts = current_account.contacts.by_reference_code(params[:reference_code])

    limit = params[:limit]&.to_i || 100

    render_formatted_json paginate_with_cursor(contacts, limit:)
  end

  def show
    render_formatted_json contact: @contact
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.account = current_account

    if @contact.save
      render_formatted_json contact: @contact, status: :created
    else
      render_validation_error_json @contact
    end
  end

  def update
    if @contact.update(contact_params)
      render_formatted_json contact: @contact
    else
      render_validation_error_json @contact
    end
  end

  def destroy
    @contact.destroy!

    head :no_content
  end

  private

  def set_contact
    @contact = current_account.contacts.find(params.expect(:id))
  end

  def contact_params
    params.expect(contact: [
      :reference_code,
      :full_name,
      :document_type,
      :document_number,
      :email,
      :phone,
      :zip_code,
      :address,
      :address_number,
      :city,
      :neighborhood,
      :state
    ])
  end
end
