# frozen_string_literal: true

module Transmittable
  extend ActiveSupport::Concern

  def transmit(maybe_result, with: nil, status: :ok, view: nil)
    return render nothing: true, status: status unless maybe_result.is_a?(Dry::Monads::Result)

    if maybe_result.success?
      params = view.nil? ? {} : { view: }

      rendered = with ? with.render(maybe_result.value!, params) : maybe_result.value!

      render json: rendered, status:
    else
      render maybe_result.failure.to_response
    end
  end
end
