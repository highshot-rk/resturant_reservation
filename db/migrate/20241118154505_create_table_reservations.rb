class CreateTableReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :table_reservations do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :table, null: false, foreign_key: true

      t.timestamps
    end
  end
end
