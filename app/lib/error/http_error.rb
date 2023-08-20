# frozen_string_literal: true

class HttpError < StandardError
  attr_accessor :data, :expose, :status

  def initialize(message, status)
    super(message)

    self.status = status
    self.data = []
    self.expose = false
  end

  def add(location, code, detail = nil)
    self.expose = true

    stat = { location:, code: }.tap do |error|
      error[:detail] = detail if detail.present?
    end

    data.push(stat)

    self
  end

  def to_json(*_args)
    {}.tap do |res|
      res[:data] = data if data.any?
      res[:message] = message if message.present?
    end
  end
end
