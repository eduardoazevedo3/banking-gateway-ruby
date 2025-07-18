module CursorPagination
  extend ActiveSupport::Concern

  private

  def paginate_with_cursor(relation, cursor_field: :id, limit: 100)
    limit = [ limit.to_i, 100 ].min # Maximum of 100 records per page
    cursor = params[:cursor]
    direction = params[:direction]&.downcase == 'desc' ? 'desc' : 'asc'

    if cursor.present?
      # Decode the cursor (base64)
      decoded_cursor = decode_cursor(cursor)

      if direction == 'desc'
        relation = relation.where("#{cursor_field} < ?", decoded_cursor)
      else
        relation = relation.where("#{cursor_field} > ?", decoded_cursor)
      end
    end

    # Apply ordering and limit
    relation = relation.order(cursor_field => direction).limit(limit + 1)

    # Check if there are more pages
    has_more = relation.count > limit
    records = relation.limit(limit)

    # Generate next cursor
    next_cursor = nil
    if has_more && records.any?
      last_record = records.last
      next_cursor = encode_cursor(last_record.send(cursor_field))
    end

    # Generate previous cursor (if applicable)
    prev_cursor = nil
    if cursor.present? && records.any?
      first_record = records.first
      prev_cursor = encode_cursor(first_record.send(cursor_field))
    end

    {
      records.model_name.collection => records,
      pagination: {
        has_more: has_more,
        next_cursor: next_cursor,
        prev_cursor: prev_cursor,
        limit: limit,
        direction: direction
      }
    }
  end

  def encode_cursor(value)
    Base64.urlsafe_encode64(value.to_s)
  end

  def decode_cursor(encoded_cursor)
    Base64.urlsafe_decode64(encoded_cursor)
  rescue ArgumentError
    raise ActionController::BadRequest, 'Invalid cursor format'
  end
end
