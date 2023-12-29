# frozen_string_literal: true

FactoryBot.define do
  factory :position, class: 'Game::Position' do
    x { 0 }
    y { 0 }
    z { 0 }
  end
end
