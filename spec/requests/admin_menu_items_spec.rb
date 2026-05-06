require "rails_helper"

RSpec.describe "Admin menu items", type: :request do
  let(:auth_header) { { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin_test", "secret_test") } }
  let!(:category) { Category.create!(name: "Dumplings", position: 1, active: true) }

  before do
    ENV["ADMIN_USER"] = "admin_test"
    ENV["ADMIN_PASS"] = "secret_test"
  end

  after do
    ENV.delete("ADMIN_USER")
    ENV.delete("ADMIN_PASS")
  end

  it "attaches an uploaded menu item photo" do
    uploaded_photo = Rack::Test::UploadedFile.new(
      Rails.root.join("db/seed_assets/menu_items/wuxi_juicy_dumpling.jpg"),
      "image/jpeg"
    )

    post admin_menu_items_path,
      params: {
        menu_item: {
          category_id: category.id,
          name: "Photo Test Dumpling",
          description: "",
          price_cents: 680,
          active: "1",
          position: 1,
          photo: uploaded_photo
        }
      },
      headers: auth_header

    menu_item = MenuItem.find_by!(name: "Photo Test Dumpling")
    expect(response).to redirect_to(admin_menu_items_path)
    expect(menu_item.photo).to be_attached
    expect(menu_item.image_url).to be_blank
  end

  it "removes an uploaded menu item photo" do
    menu_item = MenuItem.create!(category:, name: "Remove Photo Test", description: "", price_cents: 680, active: true, position: 1)
    menu_item.photo.attach(
      io: Rails.root.join("db/seed_assets/menu_items/wuxi_juicy_dumpling.jpg").open,
      filename: "wuxi_juicy_dumpling.jpg",
      content_type: "image/jpeg"
    )

    patch admin_menu_item_path(menu_item),
      params: {
        menu_item: {
          category_id: category.id,
          name: menu_item.name,
          description: menu_item.description,
          price_cents: menu_item.price_cents,
          active: "1",
          position: menu_item.position,
          remove_photo: "1"
        }
      },
      headers: auth_header

    expect(response).to redirect_to(admin_menu_items_path)
    expect(menu_item.reload.photo).not_to be_attached
  end
end
