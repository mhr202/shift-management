# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Shifts', type: :request do
  describe 'GET /index' do
    context 'when worker does not exists' do
      it 'returns exception' do
        get api_v1_worker_shifts_path(Worker.maximum(:id).to_i + 1)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to include("Couldn't find Worker")
      end
    end

    context 'when worker exists' do
      let(:worker) { create(:worker) }

      context 'when no shifts found for the worker' do
        it 'returns empty response' do
          get api_v1_worker_shifts_path(worker.id)

          expect(response).to have_http_status(:ok)
          expect(json_body).to be_empty
        end
      end

      context 'when worker has shifts' do
        let!(:shift) { create(:shift, worker: worker) }
        let!(:shift1) { create(:shift, worker: worker, day: Date.yesterday) }

        it "returns the worker's shifts" do
          get api_v1_worker_shifts_path(worker.id)

          expect(response).to have_http_status(:ok)
          expect(json_body.pluck('id')).to eq([shift.id, shift1.id])
        end
      end
    end
  end

  describe 'GET /show' do
    context 'when worker does not exists' do
      it 'returns exception' do
        get api_v1_worker_shift_path(Worker.maximum(:id).to_i + 1, Shift.maximum(:id).to_i)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to include("Couldn't find Worker")
      end
    end

    context 'when worker exists' do
      let(:worker) { create(:worker) }

      context 'when user have no shifts' do
        it 'return not found exception' do
          get api_v1_worker_shift_path(worker.id, Shift.maximum(:id).to_i + 1)

          expect(response).to have_http_status(:not_found)
          expect(json_body['message']).to include("Couldn't find Shift")
        end
      end

      context 'when user have shift' do
        let(:shift) { create(:shift, worker: worker) }

        it 'returns shift' do
          get api_v1_worker_shift_path(worker.id, shift.id)

          expect(response).to have_http_status(:ok)
          expect(json_body['id']).to eq(shift.id)
          expect(json_body['day']).to eq(shift.day.to_s)
        end
      end
    end
  end

  describe 'POST /create' do
    context 'when worker does not exists' do
      it 'returns exception' do
        post api_v1_worker_shifts_path(Worker.maximum(:id).to_i + 1)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to include("Couldn't find Worker")
      end
    end

    context 'when worker exists' do
      let(:worker) { create(:worker) }

      context 'when no params passed' do
        it 'returns exception' do
          post api_v1_worker_shifts_path(worker.id)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body['message']).to include('param is missing or the value is empty')
        end
      end

      context 'when correct params passed' do
        let(:payload) do
          {
            day: Date.today.to_s,
            shift_type: 'morning'
          }
        end

        it 'returns created shift' do
          post api_v1_worker_shifts_path(worker.id), params: payload

          expect(response).to have_http_status(:created)
          expect(json_body['day']).to eq(payload[:day])
          expect(json_body['shift_type']).to eq(payload[:shift_type])
        end

        context 'when worker wants to do double shift' do
          let!(:shift) { create(:shift, :morning, worker: worker) }

          it 'returns exception' do
            post api_v1_worker_shifts_path(worker.id), params: payload

            expect(response).to have_http_status(:unprocessable_entity)
            expect(json_body['message']).to include('Day has already been taken')
          end
        end
      end
    end
  end

  describe 'PUT /update' do
    context 'when worker does not exists' do
      it 'returns exception' do
        put api_v1_worker_shift_path(Worker.maximum(:id).to_i + 1, Shift.maximum(:id).to_i)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to include("Couldn't find Worker")
      end
    end

    context 'when worker exists' do
      let(:worker) { create(:worker) }

      context 'when shift not found' do
        it 'returns exception' do
          put api_v1_worker_shift_path(worker.id, Shift.maximum(:id).to_i)

          expect(response).to have_http_status(:not_found)
          expect(json_body['message']).to include("Couldn't find Shift")
        end
      end

      context 'when shift found' do
        let(:shift) { create(:shift, worker: worker) }
        let(:payload) do
          {
            day: Date.yesterday,
            shift_type: 'morning'
          }
        end

        context 'when worker tries to update a shift and move it to day he has another shift' do
          let!(:shift1) { create(:shift, worker: worker, day: Date.yesterday) }

          it 'returns exception' do
            put api_v1_worker_shift_path(worker.id, shift.id), params: payload

            expect(response).to have_http_status(:unprocessable_entity)
            expect(json_body['message']).to include('Day has already been taken')
          end
        end

        context "when worker update it's shift timing" do
          it 'returns updated shift' do
            put api_v1_worker_shift_path(worker.id, shift.id), params: payload

            expect(response).to have_http_status(:ok)
            expect(json_body['day']).to eq(payload[:day].to_s)
          end
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when worker does not exists' do
      it 'returns exception' do
        delete api_v1_worker_shift_path(Worker.maximum(:id).to_i + 1, Shift.maximum(:id).to_i)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to include("Couldn't find Worker")
      end
    end

    context 'when worker exists' do
      let(:worker) { create(:worker) }

      context 'when shift not found' do
        it 'returns exception' do
          delete api_v1_worker_shift_path(worker.id, Shift.maximum(:id).to_i + 1)

          expect(response).to have_http_status(:not_found)
          expect(json_body['message']).to include("Couldn't find Shift")
        end
      end

      context 'when shift found' do
        let(:shift) { create(:shift, worker: worker) }

        it 'return deleted shift' do
          delete api_v1_worker_shift_path(worker.id, shift.id)

          expect(response).to have_http_status(:ok)
          expect(json_body['id']).to eq(shift.id)
          expect(Shift.ids).not_to include(shift.id)
        end
      end
    end
  end
end
