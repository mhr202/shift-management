# frozen_string_literal: true

FactoryBot.define do
  factory :shift do
    day { Date.today }
    shift_type { Shift.shift_types.values.sample }

    worker

    trait :morning do
      shift_type { Shift.shift_types[:morning] }
    end

    trait :evening do
      shift_type { Shift.shift_types[:evening] }
    end

    trait :night do
      shift_type { Shift.shift_types[:night] }
    end
  end
end
