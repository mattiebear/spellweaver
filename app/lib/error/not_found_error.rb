# frozen_string_literal: true

class NotFoundError < HttpError
  def initialize(message = 'Not found')
    super(message, :not_found)
  end
end
