# frozen_string_literal: true

class Worker < ApplicationRecord
  has_many :shifts, dependent: :destroy

  validates :email, :first_name, presence: true
  validates :email, uniqueness: true
end
