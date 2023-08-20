# frozen_string_literal: true

class ConflictError < HttpError
  def initialize(message = 'Conflict')
    super(message, :conflict)
  end
end
