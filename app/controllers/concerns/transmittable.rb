# frozen_string_literal: true

module Transmittable 
  extend ActiveSupport::Concern

  def transmit(maybe_result, with: nil, status: :ok)
    if maybe_result.success?
      rendered = with ? with.render(maybe_result.value!) : maybe_result.value!

      render json: rendered, status:
    else
      render maybe_result.failure.to_response
    end
  end
end
