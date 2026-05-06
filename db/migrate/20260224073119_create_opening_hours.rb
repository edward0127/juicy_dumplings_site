class CreateOpeningHours < ActiveRecord::Migration[8.1]
  def change
    create_table :opening_hours do |t|
      t.integer :day_of_week, null: false
      t.string :opens_at
      t.string :closes_at
      t.boolean :closed, null: false, default: false

      t.timestamps
    end

    add_index :opening_hours, :day_of_week, unique: true
  end
end
