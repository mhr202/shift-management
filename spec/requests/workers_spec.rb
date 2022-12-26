# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Workers', type: :request do
  describe 'GET /index' do
    context 'when records does not exists' do
      it 'returns empty response' do
        get api_v1_workers_path

        expect(response).to have_http_status(:ok)
        expect(json_body).to be_empty
      end
    end

    context 'when recordes exists' do
      let!(:worker) { create(:worker) }

      it 'returns workers list' do
        get api_v1_workers_path

        expect(response).to have_http_status(:ok)
        expect(json_body.first['id']).to eq(worker.id)
      end
    end
  end

  describe 'GET /show' do
    context 'when worker does not exist' do
      it 'returns exception' do
        get api_v1_worker_path(Worker.maximum(:id).to_i + 1)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to include("Couldn't find Worker")
      end
    end

    context 'when workers exists' do
      let(:worker) { create(:worker) }

      it 'returns worker' do
        get api_v1_worker_path(worker.id)

        expect(response).to have_http_status(:ok)
        expect(json_body['id']).to eq(worker.id)
      end
    end
  end

  describe 'POST /create' do
    context 'when no/missing params provided' do
      it 'returns exception' do
        post api_v1_workers_path

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body['message']).to include('param is missing or the value is empty')
      end
    end

    context 'when params provided' do
      let(:payload) do
        {
          email: Faker::Internet.email,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name
        }
      end

      context 'when email already exists' do
        let(:worker) { create(:worker) }

        it 'returns exception' do
          payload[:email] = worker.email

          post api_v1_workers_path, params: payload

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body['message']).to include('Email has already been taken')
        end
      end

      context 'when correct params provided' do
        it 'returns created worker' do
          post api_v1_workers_path, params: payload

          expect(response).to have_http_status(:created)
          expect(json_body['email']).to eq(payload[:email])
        end
      end
    end
  end

  describe 'PUT /update' do
    context 'when worker does not exist' do
      it 'returns exception' do
        put api_v1_worker_path(Worker.maximum(:id).to_i + 1)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to include("Couldn't find Worker")
      end
    end

    context 'when worker exists' do
      let(:worker) { create(:worker) }
      let(:payload) do
        {
          email: Faker::Internet.email,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name
        }
      end

      context 'when email already exists' do
        let!(:worker1) { create(:worker) }

        it 'returns exception' do
          payload[:email] = worker1.email

          put api_v1_worker_path(worker.id), params: payload

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body['message']).to include('Email has already been taken')
        end
      end

      context 'when user has correct record' do
        it 'returns updated record' do
          put api_v1_worker_path(worker.id), params: payload

          expect(response).to have_http_status(:ok)
          expect(json_body['email']).to eq(payload[:email])
        end
      end
    end
  end
end
