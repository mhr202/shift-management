# frozen_string_literal: true

FactoryBot.define do
  factory :worker do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
