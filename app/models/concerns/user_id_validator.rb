# frozen_string_literal: true

class UserIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /\Auser_[a-zA-Z0-9]+\z/i

    record.errors.add attribute, (options[:message] || 'is not a valid user id')
  end
end
