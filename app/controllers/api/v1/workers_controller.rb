# frozen_string_literal: true

module Api
  module V1
    class WorkersController < BaseController
      actions :index, :create, :show, :update

      private

      def permitted_params
        params.require(%i[email first_name])

        params.permit(:id, :email, :first_name, :last_name)
      end
    end
  end
end
