class TableReservation < ApplicationRecord
  belongs_to :reservation
  belongs_to :table
end
