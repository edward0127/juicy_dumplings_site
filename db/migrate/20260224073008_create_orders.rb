class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :public_id, null: false
      t.string :customer_name, null: false
      t.string :customer_phone
      t.string :customer_email
      t.integer :order_type, null: false, default: 0
      t.datetime :pickup_time
      t.text :notes
      t.integer :subtotal_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :stripe_session_id
      t.boolean :paid, null: false, default: false
      t.string :delivery_address

      t.timestamps
    end

    add_index :orders, :public_id, unique: true
    add_index :orders, :stripe_session_id
    add_index :orders, :pickup_time
    add_index :orders, :status
  end
end
