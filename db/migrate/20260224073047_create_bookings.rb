class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.string :name, null: false
      t.string :phone
      t.string :email
      t.integer :party_size, null: false
      t.datetime :booking_time, null: false
      t.text :notes
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :bookings, :booking_time
    add_index :bookings, :status
  end
end
