require "rails_helper"

RSpec.describe "Admin CSV exports", type: :request do
  let(:auth_header) { { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin_test", "secret_test") } }

  before do
    ENV["ADMIN_USER"] = "admin_test"
    ENV["ADMIN_PASS"] = "secret_test"

    BusinessSetting.current.update!(slot_interval_minutes: 30, max_bookings_per_slot: 8)

    export_time = 1.day.from_now.change(hour: 12, min: 0, sec: 0)
    OpeningHour.find_or_initialize_by(day_of_week: export_time.wday).tap do |hour|
      hour.opens_at = "00:00"
      hour.closes_at = "23:59"
      hour.closed = false
      hour.save!
    end

    category = Category.create!(name: "Dumplings", position: 1, active: true)
    menu_item = MenuItem.create!(category: category, name: "Pork Dumplings", description: "", price_cents: 1200, active: true, position: 1)

    order = Order.new(customer_name: "Casey", customer_phone: "0400000000", order_type: :pickup, pickup_time: export_time)
    order.order_items.build(menu_item: menu_item, quantity: 1, unit_price_cents: menu_item.price_cents)
    order.save!

    Booking.create!(name: "Morgan", phone: "0400000001", booking_time: export_time, party_size: 2)
  end

  after do
    ENV.delete("ADMIN_USER")
    ENV.delete("ADMIN_PASS")
  end

  it "exports orders CSV" do
    get export_admin_orders_path(format: :csv), headers: auth_header

    expect(response).to have_http_status(:ok)
    expect(response.content_type).to include("text/csv")
    expect(response.body).to include("public_id")
  end

  it "exports bookings CSV" do
    get export_admin_bookings_path(format: :csv), headers: auth_header

    expect(response).to have_http_status(:ok)
    expect(response.content_type).to include("text/csv")
    expect(response.body).to include("party_size")
  end
end
