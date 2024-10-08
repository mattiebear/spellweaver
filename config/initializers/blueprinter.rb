# frozen_string_literal: true

Blueprinter.configure do |config|
  config.datetime_format = ->(datetime) { datetime.nil? ? datetime : datetime.iso8601 }
end
