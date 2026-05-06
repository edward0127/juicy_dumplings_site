class ContactMessageForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :contact, :string
  attribute :message, :string
  attribute :website, :string

  validates :name, :contact, :message, presence: true

  def spam?
    website.present?
  end
end
