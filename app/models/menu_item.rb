class MenuItem < ApplicationRecord
  MAX_PHOTO_SIZE = 5.megabytes

  belongs_to :category
  has_many :order_items, dependent: :restrict_with_exception
  has_one_attached :photo

  validates :name, presence: true
  validates :price_cents, numericality: { greater_than: 0, only_integer: true }
  validates :position, numericality: { greater_than_or_equal_to: 0 }
  validate :photo_is_valid

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc, name: :asc) }

  def price
    price_cents.to_i / 100.0
  end

  def dietary_tags
    [].tap do |tags|
      tags << "Spicy" if spicy?
      tags << "Vegetarian" if vegetarian?
      tags << "Gluten Free" if gluten_free?
    end
  end

  private

  def photo_is_valid
    return unless photo.attached?

    unless photo.blob.content_type.to_s.start_with?("image/")
      errors.add(:photo, "must be an image file")
    end

    if photo.blob.byte_size > MAX_PHOTO_SIZE
      errors.add(:photo, "must be smaller than 5 MB")
    end
  end
end
