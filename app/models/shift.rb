# frozen_string_literal: true

class Shift < ApplicationRecord
  belongs_to :worker

  validates :day, :shift_type, presence: true
  validates :day, uniqueness: { scope: :worker_id }

  enum :shift_type, { morning: '0-8', evening: '8-16', night: '16-24' }
end
