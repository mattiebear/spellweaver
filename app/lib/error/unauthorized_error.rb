# frozen_string_literal: true

class UnauthorizedError < HttpError
  def initialize(message = 'Not authorized')
    super(message, :unauthorized)
  end
end
