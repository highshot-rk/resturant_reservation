require 'rails_helper'

RSpec.describe Table, type: :model do
  describe '#available?' do
    let(:table) { create(:table) }
    let(:reservation_time) { Time.current + 2.days }
    let(:duration) { 2 }

    context "when the table has no conflicting reservations" do
      it "should be true" do
        expect(table.available?(reservation_time, duration)).to be_truthy
      end
    end
    
    context "when there is overlapped reservation" do
      before {create(:reservation, reservation_time: reservation_time, duration: duration, tables: [table], status: :confirmed)}

      it "should be false" do
        expect(table.available?(reservation_time, duration)).to be_falsey
      end
    end
  end
end
