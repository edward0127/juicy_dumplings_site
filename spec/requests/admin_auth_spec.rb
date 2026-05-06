require "rails_helper"

RSpec.describe "Admin authentication", type: :request do
  before do
    ENV["ADMIN_USER"] = "admin_test"
    ENV["ADMIN_PASS"] = "secret_test"
  end

  after do
    ENV.delete("ADMIN_USER")
    ENV.delete("ADMIN_PASS")
  end

  it "requires basic auth for admin routes" do
    get admin_root_path

    expect(response).to have_http_status(:unauthorized)
  end

  it "allows authenticated access" do
    get admin_root_path, headers: { "HTTP_AUTHORIZATION" => basic_auth("admin_test", "secret_test") }

    expect(response).to have_http_status(:ok)
  end

  def basic_auth(user, pass)
    ActionController::HttpAuthentication::Basic.encode_credentials(user, pass)
  end
end
