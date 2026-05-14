require "rails_helper"

RSpec.describe "Admin tour", type: :request do
  let(:auth_header) { { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin_test", "secret_test") } }

  before do
    ENV["ADMIN_USER"] = "admin_test"
    ENV["ADMIN_PASS"] = "secret_test"
  end

  after do
    ENV.delete("ADMIN_USER")
    ENV.delete("ADMIN_PASS")
  end

  it "renders the dashboard with the first-time tour shell" do
    get admin_root_path, headers: auth_header

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('data-controller="admin-tour"')
    expect(response.body).to include('data-admin-tour-page-value="dashboard"')
    expect(response.body).to include('data-admin-tour-storage-key-value="juicy_admin_tour_seen_v1"')
    expect(response.body).to include("Show guide")
    expect(response.body).to include("Skip tour")
  end

  it "marks key admin pages with page-specific guide context" do
    page_contexts = {
      admin_root_path => "dashboard",
      admin_orders_path => "orders",
      admin_bookings_path => "bookings",
      admin_menu_items_path => "menu-items",
      admin_categories_path => "categories",
      admin_opening_hours_path => "hours",
      edit_admin_settings_path => "settings"
    }

    page_contexts.each do |path, page|
      get path, headers: auth_header

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(%(data-admin-tour-page-value="#{page}"))
    end
  end
end
