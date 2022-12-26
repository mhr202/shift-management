# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Worker, type: :model do
  describe 'Associations' do
    it { should have_many(:shifts).dependent(:destroy) }
  end

  describe 'Validations' do
    context '.presence' do
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:first_name) }
    end

    context 'uniqueness' do
      let!(:worker) { create(:worker) }

      it { should validate_uniqueness_of(:email) }
    end
  end
end
