class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def total_cents
    quantity.to_i * unit_price_cents.to_i
  end
end
