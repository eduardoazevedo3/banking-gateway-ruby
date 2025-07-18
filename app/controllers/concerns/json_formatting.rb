module JsonFormatting
  extend ActiveSupport::Concern

  included do
    before_action :normalize_request_params
  end

  private

  def normalize_request_params
    return unless request.content_type&.include?('application/json')
    return unless request.body.read.present?

    if response_format == 'camel_case'
      request.body.rewind
      body_content = request.body.read

      normalized_params = convert_camel_case_to_snake_case(JSON.parse(body_content))
      request.body.rewind
      request.body.write(normalized_params.to_json)
    end
  end

  def convert_camel_case_to_snake_case(data)
    case data
    when Hash
      data.transform_keys { |key| key.to_s.underscore }
          .transform_values { |value| convert_camel_case_to_snake_case(value) }
    when Array
      data.map { |item| convert_camel_case_to_snake_case(item) }
    else
      data
    end
  end

  def format_response(data)
    case response_format
    when 'camel_case'
      convert_to_camel_case(data)
    when 'snake_case'
      data
    else
      # Default to snake_case
      data
    end
  end

  def response_format
    @response_format ||= begin
      format = request.headers['X-Case-Format']&.downcase

      case format
      when 'camel', 'camelcase', 'camel_case'
        'camel_case'
      else
        'snake_case' # default
      end
    end
  end

  def convert_to_camel_case(data)
    case data
    when Hash
      data.transform_keys { |key| key.to_s.camelize(:lower) }
          .transform_values { |value| convert_to_camel_case(value) }
    when Array
      data.map { |item| convert_to_camel_case(item) }
    when ActiveRecord::Base, ActiveRecord::Relation
      convert_to_camel_case(data.as_json)
    when ActionController::Parameters
      convert_to_camel_case(data.to_unsafe_h)
    else
      data
    end
  end

  def render_formatted_json(data, options = {})
    # formatted_data = format_response(data)
    render json: data, **options
  end
end
