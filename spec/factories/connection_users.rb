# frozen_string_literal: true

FactoryBot.define do
  factory :connection_user do
    user_id { 'MyString' }
    role { 1 }
    connection { nil }
  end
end
