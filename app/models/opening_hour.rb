class OpeningHour < ApplicationRecord
  DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze
  TIME_FORMAT = /\A([01]\d|2[0-3]):([0-5]\d)\z/.freeze

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }, uniqueness: true
  validates :opens_at, :closes_at, presence: true, unless: :closed?
  validates :opens_at, :closes_at, format: { with: TIME_FORMAT }, allow_blank: true
  validate :opens_before_closes, unless: :closed?

  scope :ordered, -> { order(:day_of_week) }

  def day_name
    DAYS.fetch(day_of_week)
  end

  def within_hours?(time)
    return false if closed?

    open_time = parse_time_on(time.to_date, opens_at)
    close_time = parse_time_on(time.to_date, closes_at)
    return false if open_time.nil? || close_time.nil?

    time.between?(open_time, close_time)
  end

  def slot_times_for(date, interval_minutes)
    return [] if closed?

    open_time = parse_time_on(date, opens_at)
    close_time = parse_time_on(date, closes_at)
    return [] if open_time.nil? || close_time.nil?

    slots = []
    current_time = open_time
    while current_time < close_time
      slots << current_time
      current_time += interval_minutes.minutes
    end
    slots
  end

  def self.for_time(time)
    find_by(day_of_week: time.wday)
  end

  private

  def opens_before_closes
    open_minutes = minutes_from_hhmm(opens_at)
    close_minutes = minutes_from_hhmm(closes_at)
    return if open_minutes.nil? || close_minutes.nil?
    return if open_minutes < close_minutes

    errors.add(:closes_at, "must be later than opening time")
  end

  def parse_time_on(date, hhmm)
    hours, minutes = hhmm.to_s.split(":").map(&:to_i)
    Time.zone.local(date.year, date.month, date.day, hours, minutes)
  rescue StandardError
    nil
  end

  def minutes_from_hhmm(hhmm)
    match = hhmm.to_s.match(TIME_FORMAT)
    return nil if match.nil?

    (match[1].to_i * 60) + match[2].to_i
  end
end
