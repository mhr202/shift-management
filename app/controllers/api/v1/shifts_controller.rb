# frozen_string_literal: true

module Api
  module V1
    class ShiftsController < BaseController
      actions :index, :create, :show, :destroy, :update

      private

      def new_resource
        @new_resource ||= collection.new(permitted_params)
      end

      def collection
        @collection ||= worker.shifts
      end

      def resource
        @resource ||= collection.find(params[:id])
      end

      def worker
        @worker ||= Worker.find(params[:worker_id])
      end

      def permitted_params
        params.require(%i[day shift_type])

        params.permit(:id, :day, :shift_type, :worker_id)
      end
    end
  end
end
