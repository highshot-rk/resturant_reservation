class Table < ApplicationRecord
  extend Enumerize

  has_many :table_reservations
  has_many :reservations, through: :table_reservations

  validates :capacity, presence: true

  enumerize :location,
            in: {
              window: 0,
              patio: 1,
            }, scope: true


  def available?(start_time, duration)
    reservations.none? do |reservation|
      next if !reservation.status.confirmed?

      reservation_end_time = reservation.reservation_time + reservation.duration.hours
      requested_end_time = start_time + duration.hours

      (reservation.reservation_time...reservation_end_time).overlaps?(start_time..requested_end_time)
    end
  end
end
