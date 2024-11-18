class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.string :name, null: false
      t.datetime :reservation_time, null: false, comment: 'date and time'
      t.integer :duration, null: false, default: 1, comment: 'default 1 hr and it will be 2hr, 3hr, etc'
      t.integer :reservation_capacity, null: false
      t.integer :status, null: false, default: 0, comment: '0: confirmed, 1: cancelled, 2: completed, 3: absent'

      t.timestamps
    end
  end
end
