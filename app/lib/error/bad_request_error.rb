# frozen_string_literal: true

class BadRequestError < HttpError
  def initialize(message = 'Bad request')
    super(message, :bad_request)
  end
end
