class CreateMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_items do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :price_cents, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.boolean :spicy, null: false, default: false
      t.boolean :vegetarian, null: false, default: false
      t.boolean :gluten_free, null: false, default: false
      t.string :image_url
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :menu_items, :position
  end
end
