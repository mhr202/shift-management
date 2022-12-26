# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include BaseHandler
      include ExceptionHandler

      private

      def index
        render json: collection
      end

      def show
        render json: resource
      end

      def create
        if new_resource.save
          render json: new_resource, status: :created
        else
          render json: { message: new_resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if resource.update(permitted_params)
          render json: resource
        else
          render json: { message: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if resource.destroy
          render json: resource
        else
          render json: { message: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def collection
        @collection ||= model.all
      end

      def resource
        @resource ||= model.find(params[:id])
      end

      def new_resource
        @new_resource ||= model.new(permitted_params)
      end

      def permitted_params
        params.permit
      end
    end
  end
end
