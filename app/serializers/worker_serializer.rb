# frozen_string_literal: true

class WorkerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email

  has_many :shifts
end
