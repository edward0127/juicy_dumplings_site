require "rails_helper"

RSpec.describe MenuItem, type: :model do
  let(:category) { Category.create!(name: "Dumplings", position: 1, active: true) }

  it "requires a name" do
    menu_item = described_class.new(category: category, price_cents: 1200)

    expect(menu_item).not_to be_valid
    expect(menu_item.errors[:name]).to include("can't be blank")
  end

  it "requires a positive price" do
    menu_item = described_class.new(category: category, name: "Pork Dumplings", price_cents: nil)

    expect(menu_item).not_to be_valid
    expect(menu_item.errors[:price_cents]).not_to be_empty
  end

  it "only allows image photo attachments" do
    menu_item = described_class.new(category: category, name: "Pork Dumplings", price_cents: 1200)
    menu_item.photo.attach(io: StringIO.new("not an image"), filename: "menu.txt", content_type: "text/plain")

    expect(menu_item).not_to be_valid
    expect(menu_item.errors[:photo]).to include("must be an image file")
  end
end
