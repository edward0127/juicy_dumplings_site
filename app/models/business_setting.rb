class BusinessSetting < ApplicationRecord
  SLOT_INTERVAL_OPTIONS = [15, 30].freeze
  DEFAULT_HOURS_NOTE = "Please update opening hours in admin settings.".freeze

  validates :business_name, :suburb, :address, presence: true
  validates :slot_interval_minutes, inclusion: { in: SLOT_INTERVAL_OPTIONS }
  validates :max_bookings_per_slot, numericality: { only_integer: true, greater_than: 0 }

  def self.current
    first_or_create!(hours_note: DEFAULT_HOURS_NOTE)
  end

  def owner_notification_email
    owner_email.presence || ENV["OWNER_EMAIL"].presence || email
  end
end
