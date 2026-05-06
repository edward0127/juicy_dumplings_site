require "rails_helper"

RSpec.describe "Order placement", type: :request do
  let(:order_time) { 1.day.from_now.change(hour: 12, min: 0, sec: 0) }
  let!(:category) { Category.create!(name: "Dumplings", position: 1, active: true) }
  let!(:menu_item) { MenuItem.create!(category: category, name: "Pork Dumplings", description: "", price_cents: 1200, active: true, position: 1) }

  before do
    BusinessSetting.current.update!(ordering_enabled: true, pay_at_pickup_enabled: true)
    OpeningHour.find_or_initialize_by(day_of_week: order_time.wday).tap do |hour|
      hour.opens_at = "00:00"
      hour.closes_at = "23:59"
      hour.closed = false
      hour.save!
    end
  end

  it "places an order using pay-at-pickup flow" do
    post cart_item_add_path(menu_item), params: { quantity: 2 }

    post order_path, params: {
      order: {
        customer_name: "Chris",
        customer_phone: "0400000000",
        customer_email: "",
        order_type: "pickup",
        pickup_time: order_time,
        notes: "No coriander",
        payment_method: "pay_at_pickup"
      }
    }

    order = Order.last

    expect(response).to redirect_to(order_confirmation_path(order.public_id))
    expect(order).to be_present
    expect(order.order_items.sum(:quantity)).to eq(2)
    expect(order.paid).to eq(false)
    expect(order.status).to eq("confirmed")
  end
end
