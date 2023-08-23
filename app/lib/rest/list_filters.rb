# frozen_string_literal: true

module Rest
  class ListFilters
    def initialize(params, *keys)
      @params = params
      @keys = keys
    end

    def filters
      keys.reduce({}) do |hash, key|
        if params[key].present?
          hash.merge(key => params[key])
        else
          hash
        end
      end
    end

    private

    attr_reader :params, :keys
  end
end
