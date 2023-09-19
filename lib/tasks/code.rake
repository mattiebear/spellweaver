# frozen_string_literal: true

namespace :code do
  desc 'Formats code using Rubocop styling'
  task format: :environment do
    `bundle exec rubocop -A`
  end
end
