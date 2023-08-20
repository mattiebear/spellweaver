# frozen_string_literal: true

class AtlasValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.is_a?(Hash) && value['version'].is_a?(String) && value['data'].is_a?(Array)

    record.errors.add attribute, (options[:message] || 'is not a valid atlas')
  end
end
