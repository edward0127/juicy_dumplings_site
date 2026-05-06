require "rails_helper"

RSpec.describe "Booking creation", type: :request do
  before do
    BusinessSetting.current.update!(slot_interval_minutes: 30, max_bookings_per_slot: 8)

    tomorrow = Date.current + 1.day
    OpeningHour.find_or_create_by!(day_of_week: tomorrow.wday) do |hour|
      hour.opens_at = "10:00"
      hour.closes_at = "22:00"
      hour.closed = false
    end
  end

  it "creates a booking" do
    booking_time = (Time.current + 1.day).change(hour: 12, min: 0)

    post book_path, params: {
      booking: {
        name: "Jamie",
        phone: "0400000000",
        email: "",
        party_size: 4,
        booking_time: booking_time,
        notes: "Window table"
      }
    }

    booking = Booking.last

    expect(response).to redirect_to(booking_confirmation_path(booking))
    expect(booking.name).to eq("Jamie")
    expect(booking.status).to eq("pending")
  end
end
