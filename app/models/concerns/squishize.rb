module Squishize
  extend ActiveSupport::Concern

  class_methods do
    def squishize(*attrs)
      return if attrs.size.zero?

      attrs.each do |a|
        define_method("#{a}=") do |value|
          super attributes[a] = value.to_s.squish
        end
      end
    end
  end
end
