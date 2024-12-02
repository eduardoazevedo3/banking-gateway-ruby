module ValidateAssociation
  extend ActiveSupport::Concern

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def validates_association(model, args)
      return unless args.is_a?(Hash) && args[:scope]

      # module_eval <<-RUBY
      #   validate do
      #     next if #{args[:foreign_key] || "#{model}_id"}.blank?
      #     next if #{model.to_s.camelize.constantize}.find_by(id: #{args[:foreign_key] || "#{model}_id"}, account_id: #{args[:scope]}_id)
      #     errors.add(:#{args[:foreign_key] || model}, I18n.t('errors.messages.invalid'))
      #   end
      # RUBY

      define_method("validate_#{model}_association") do
        return if send(args[:foreign_key] || "#{model}_id").blank?
        return if model.to_s.camelize.constantize.find_by(id: send(args[:foreign_key] || "#{model}_id"),
          account_id: send("#{args[:scope]}_id"))

        errors.add(args[:foreign_key] || model, I18n.t('errors.messages.invalid'))
      end

      # validate :"validate_#{model}_association"
    end
  end
end
