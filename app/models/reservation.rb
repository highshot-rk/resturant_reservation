class Reservation < ApplicationRecord
  extend Enumerize

  has_many :table_reservations
  has_many :tables, through: :table_reservations

  validates :name, :reservation_time, :reservation_capacity, presence: true
  validate :reservation_in_future, on: :create, if: -> { reservation_time.present? }
  validate :check_availability, on: :create, if: -> { reservation_time.present? && reservation_capacity.present? }

  after_create :allocate_tables

  enumerize :status,
            in: {
              confirmed: 0,
              cancelled: 1,
              completed: 2,
              absent: 3
            }, scope: true

  private

    def reservation_in_future
      if reservation_time < Time.current
        errors.add(:reservation_time, "must be in the future.")
      end
    end

    def check_availability
      total_available_capacity = available_tables.sum(&:capacity)
      if total_available_capacity < reservation_capacity
        errors.add(:base, "Not enough tables available to accommodate this reservation.")
      end
    end

    def allocate_tables
      ActiveRecord::Base.transaction do
        remaining_capacity = reservation_capacity
        tables = available_tables.sort_by(&:capacity)
    
        tables.each do |table|
          break if remaining_capacity <= 0
    
          if table.capacity >= remaining_capacity
            TableReservation.create!(reservation: self, table: table)
            remaining_capacity = 0
          else
            TableReservation.create!(reservation: self, table: table)
            remaining_capacity -= table.capacity
          end
        end
    
        if remaining_capacity > 0
          errors.add(:base, "Couldn't fully allocate seating for this reservation.")
          raise ActiveRecord::Rollback
        end
      end
    end    

    def available_tables
      Table.all.select {|table| table.available?(reservation_time, duration)}
    end
end
