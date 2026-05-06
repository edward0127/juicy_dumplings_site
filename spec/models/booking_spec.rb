require "rails_helper"

RSpec.describe Booking, type: :model do
  before do
    BusinessSetting.current.update!(slot_interval_minutes: 30, max_bookings_per_slot: 1)
    OpeningHour.find_or_create_by!(day_of_week: 1) do |hour|
      hour.opens_at = "10:00"
      hour.closes_at = "22:00"
      hour.closed = false
    end
  end

  it "requires booking time in the future" do
    booking = described_class.new(name: "Taylor", party_size: 2, phone: "0400000000", booking_time: 1.hour.ago)

    expect(booking).not_to be_valid
    expect(booking.errors[:booking_time]).to include("must be in the future")
  end

  it "requires party size greater than zero" do
    booking = described_class.new(name: "Taylor", phone: "0400000000", booking_time: next_monday_at("12:00"), party_size: 0)

    expect(booking).not_to be_valid
    expect(booking.errors[:party_size]).not_to be_empty
  end

  it "rejects bookings outside opening hours" do
    booking = described_class.new(name: "Taylor", phone: "0400000000", booking_time: next_monday_at("09:00"), party_size: 2)

    expect(booking).not_to be_valid
    expect(booking.errors[:booking_time]).to include("is outside opening hours")
  end

  it "enforces slot capacity" do
    described_class.create!(name: "First", phone: "0400000000", booking_time: next_monday_at("12:00"), party_size: 2)
    second = described_class.new(name: "Second", phone: "0400000001", booking_time: next_monday_at("12:00"), party_size: 2)

    expect(second).not_to be_valid
    expect(second.errors[:booking_time]).to include("is fully booked")
  end

  def next_monday_at(hhmm)
    date = Date.current
    date += 1.day until date.monday? && date > Date.current
    Time.zone.parse("#{date} #{hhmm}")
  end
end
