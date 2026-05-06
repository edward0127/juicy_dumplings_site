class CreateBusinessSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :business_settings do |t|
      t.string :business_name, null: false, default: "Juicy Dumplings"
      t.string :suburb, null: false, default: "Doncaster East, VIC"
      t.string :address, null: false, default: "2/261 Blackburn Rd, Doncaster East VIC 3109"
      t.string :phone, default: "0425 112 889"
      t.string :email
      t.string :owner_email
      t.string :hours_note
      t.boolean :ordering_enabled, null: false, default: true
      t.boolean :pay_at_pickup_enabled, null: false, default: true
      t.integer :slot_interval_minutes, null: false, default: 30
      t.integer :max_bookings_per_slot, null: false, default: 8
      t.string :price_range, null: false, default: "$$"

      t.timestamps
    end
  end
end
