class ApplicationController < ActionController::API
  include CursorPagination
  include JsonFormatting

  class UnauthorizedError < ActionController::ActionControllerError; end

  rescue_from UnauthorizedError do
    render json: { error: 'You are not authorized to access this resource.' }, status: :unauthorized
  end

  def current_account
    @current_account ||= Account.find(
      request.headers['X-Account-Id']
    )
  rescue ActiveRecord::RecordNotFound
    raise UnauthorizedError
  end
end
