class Order < ApplicationRecord
  attr_accessor :payment_method

  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items

  enum :order_type, { pickup: 0, delivery_request: 1 }, prefix: true
  enum :status, {
    new: 0,
    confirmed: 1,
    in_kitchen: 2,
    completed: 3,
    cancelled: 4
  }, prefix: true

  validates :customer_name, presence: true
  validates :order_type, :status, presence: true
  validates :subtotal_cents, :total_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :customer_email, presence: true, unless: -> { customer_phone.present? }
  validates :customer_phone, presence: true, unless: -> { customer_email.present? }
  validates :pickup_time, presence: true, if: :order_type_pickup?
  validate :pickup_time_in_future, if: :order_type_pickup?
  validate :pickup_time_within_opening_hours, if: :order_type_pickup?
  validate :has_order_items

  before_validation :assign_public_id, on: :create
  before_validation :calculate_totals

  scope :recent, -> { order(created_at: :desc) }

  def subtotal
    subtotal_cents.to_i / 100.0
  end

  def total
    total_cents.to_i / 100.0
  end

  def payment_required?
    !paid? && !BusinessSetting.current.pay_at_pickup_enabled?
  end

  private

  def assign_public_id
    self.public_id ||= loop do
      token = "JD#{SecureRandom.hex(4).upcase}"
      break token unless self.class.exists?(public_id: token)
    end
  end

  def calculate_totals
    calculated_subtotal = order_items.map(&:total_cents).sum
    self.subtotal_cents = calculated_subtotal
    self.total_cents = calculated_subtotal
  end

  def pickup_time_in_future
    return if pickup_time.blank?
    return if pickup_time > Time.current

    errors.add(:pickup_time, "must be in the future")
  end

  def pickup_time_within_opening_hours
    return if pickup_time.blank?

    opening_hour = OpeningHour.for_time(pickup_time)
    return if opening_hour&.within_hours?(pickup_time)

    errors.add(:pickup_time, "is outside opening hours")
  end

  def has_order_items
    return if order_items.reject(&:marked_for_destruction?).any?

    errors.add(:base, "Order must include at least one item")
  end
end
