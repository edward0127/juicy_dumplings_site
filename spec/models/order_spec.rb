require "rails_helper"

RSpec.describe Order, type: :model do
  let!(:category) { Category.create!(name: "Dumplings", position: 1, active: true) }
  let!(:menu_item) { MenuItem.create!(category: category, name: "Pork Dumplings", description: "", price_cents: 1200, active: true, position: 1) }

  before do
    BusinessSetting.current.update!(slot_interval_minutes: 30, max_bookings_per_slot: 8)
    OpeningHour.find_or_create_by!(day_of_week: Time.current.wday) do |hour|
      hour.opens_at = "00:00"
      hour.closes_at = "23:59"
      hour.closed = false
    end
  end

  it "requires customer name" do
    order = described_class.new(order_type: :pickup, pickup_time: 2.hours.from_now)
    order.order_items.build(menu_item: menu_item, quantity: 1, unit_price_cents: menu_item.price_cents)

    expect(order).not_to be_valid
    expect(order.errors[:customer_name]).to include("can't be blank")
  end

  it "requires either email or phone" do
    order = described_class.new(customer_name: "Alex", order_type: :pickup, pickup_time: 2.hours.from_now)
    order.order_items.build(menu_item: menu_item, quantity: 1, unit_price_cents: menu_item.price_cents)

    expect(order).not_to be_valid
    expect(order.errors[:customer_email]).not_to be_empty
    expect(order.errors[:customer_phone]).not_to be_empty
  end

  it "requires at least one order item" do
    order = described_class.new(
      customer_name: "Alex",
      customer_phone: "0400000000",
      order_type: :pickup,
      pickup_time: 2.hours.from_now
    )

    expect(order).not_to be_valid
    expect(order.errors[:base]).to include("Order must include at least one item")
  end

  it "requires pickup time for pickup orders" do
    order = described_class.new(customer_name: "Alex", customer_phone: "0400000000", order_type: :pickup)
    order.order_items.build(menu_item: menu_item, quantity: 1, unit_price_cents: menu_item.price_cents)

    expect(order).not_to be_valid
    expect(order.errors[:pickup_time]).to include("can't be blank")
  end
end
