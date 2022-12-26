# frozen_string_literal: true

class ShiftSerializer < ActiveModel::Serializer
  attributes :id, :day, :shift_type

  belongs_to :worker
end
