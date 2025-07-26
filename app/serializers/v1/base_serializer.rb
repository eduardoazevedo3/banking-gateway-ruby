class V1::BaseSerializer
  def include?(key)
    return unless options[:includes]&.is_a?(Array)

    items = options[:includes].map do |item|
      if item.is_a?(String) && item.include?('.')
        parts = item.split('.')
        next if parts.size != 2
        { parts[0].to_sym => [ parts[1].to_sym ] }
      elsif item.is_a?(String)
        item.to_sym
      elsif item.is_a?(Symbol)
        item
      end
    end

    return {} if items.include?(key.to_sym)

    key_included = items.find { |item| item.is_a?(Hash) && item.key?(key) }&.dig(key)
    key_included if key_included
  end
end
