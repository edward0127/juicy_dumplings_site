class Booking < ApplicationRecord
  enum :status, {
    pending: 0,
    confirmed: 1,
    cancelled: 2,
    no_show: 3
  }, prefix: true

  validates :name, :booking_time, presence: true
  validates :party_size, numericality: { only_integer: true, greater_than: 0 }
  validates :email, presence: true, unless: -> { phone.present? }
  validates :phone, presence: true, unless: -> { email.present? }
  validate :booking_time_in_future
  validate :within_opening_hours
  validate :slot_capacity_available

  scope :recent, -> { order(booking_time: :asc) }

  def self.available_slots_for(date)
    settings = BusinessSetting.current
    day_time = date.in_time_zone.beginning_of_day
    opening_hour = OpeningHour.for_time(day_time)
    return [] if opening_hour.nil?

    opening_hour.slot_times_for(date, settings.slot_interval_minutes)
  end

  private

  def booking_time_in_future
    return if booking_time.blank?
    return if booking_time > Time.current

    errors.add(:booking_time, "must be in the future")
  end

  def within_opening_hours
    return if booking_time.blank?

    opening_hour = OpeningHour.for_time(booking_time)
    unless opening_hour&.within_hours?(booking_time)
      errors.add(:booking_time, "is outside opening hours")
    end
  end

  def slot_capacity_available
    return if booking_time.blank?

    settings = BusinessSetting.current
    slot_start = booking_time
    slot_end = slot_start + settings.slot_interval_minutes.minutes
    count = Booking.where(booking_time: slot_start...slot_end)
                   .where.not(id: id)
                   .where(status: %i[pending confirmed])
                   .count
    return if count < settings.max_bookings_per_slot

    errors.add(:booking_time, "is fully booked")
  end
end
