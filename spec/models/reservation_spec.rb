require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'custom validations' do
    let(:table) { create(:table, capacity: 4) }

    context 'when reservation time is in the past' do
      it 'adds an error' do
        reservation = build(:reservation, reservation_time: Time.current - 1.day)
        reservation.valid?
        expect(reservation.errors[:reservation_time]).to include('must be in the future.')
      end
    end

    context 'when capacity exceeds available tables' do
      it 'adds an error' do
        reservation = build(:reservation, reservation_capacity: 5)
        allow(reservation).to receive(:available_tables).and_return([table])
        reservation.valid?
        expect(reservation.errors[:base]).to include('Not enough tables available to accommodate this reservation.')
      end
    end
  end

  describe '#allocate_tables' do
    let!(:table1) { create(:table, capacity: 4) }
    let!(:table2) { create(:table, capacity: 6) }
    subject { TableReservation.count }

    context "when host can allocate table" do
      before {create(:reservation, reservation_capacity: 2, reservation_time: Time.current + 2.hours)}

      it "1 table reservation will be created" do
        is_expected.to eq 1
      end
    end

    context "when tables fully filled" do
      it "table reservation can not be created and got error" do
        reservation = build(:reservation, reservation_capacity: 15, reservation_time: Time.current + 2.hours)
        expect(reservation.save).to eq(false)
        expect(reservation.errors[:base]).to include("Not enough tables available to accommodate this reservation.")
      end
    end
  end
end
