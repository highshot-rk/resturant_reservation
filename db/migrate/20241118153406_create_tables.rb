class CreateTables < ActiveRecord::Migration[8.0]
  def change
    create_table :tables do |t|
      t.integer :capacity, null: false
      t.integer :location, comment: 'window, patio, etc but the future feature'

      t.timestamps
    end
  end
end
