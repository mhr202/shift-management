# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |resource|
      render json: { message: resource.message }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { message: e }, status: :unprocessable_entity
    end
  end
end
