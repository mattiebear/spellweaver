# frozen_string_literal: true

class CommandFailure
  attr_reader :data, :message, :status

  def initialize(status)
    @data = []
    @message = generate_message
    @status = status
  end

  def add(location, code, detail = nil)
    stat = { location:, code: }

    stat[:detail] = detail if detail.present?

    data.push(stat)

    self
  end

  def to_json(*_args)
    {}.tap do |res|
      res[:data] = data if data.any?
      res[:message] = message if message.present?
    end
  end

  def to_response
    { json: to_json, status: }
  end

  private

  attr_writer :data, :message

  def generate_message
    self.message = status.to_s.titleize
  end
end
