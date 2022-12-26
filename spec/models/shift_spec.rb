# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'Associations' do
    it { should belong_to(:worker) }
  end

  describe 'Validations' do
    context '.presence' do
      it { should validate_presence_of(:day) }
      it { should validate_presence_of(:shift_type) }
    end

    context '.uniqueness' do
      let!(:shift) { create(:shift) }

      it { should validate_uniqueness_of(:day).scoped_to(:worker_id) }
    end

    context '.shift_type enum' do
      it { should define_enum_for(:shift_type).with_values(Shift.shift_types).backed_by_column_of_type(:string) }
    end
  end
end
