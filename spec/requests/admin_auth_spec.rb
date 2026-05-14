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

  it "redirects unauthenticated admin requests to the login page" do
    get admin_root_path

    expect(response).to redirect_to(admin_login_path)
    expect(flash[:alert]).to eq("Please sign in to continue.")
  end

  it "loads the login page" do
    get admin_login_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Sign in to manage the restaurant")
    expect(response.body).to include("Password")
  end

  it "signs in with valid credentials and returns to the requested admin page" do
    get admin_orders_path

    post admin_login_path, params: { username: "admin_test", password: "secret_test" }

    expect(response).to redirect_to(admin_orders_path)

    follow_redirect!
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Orders")
    expect(response.body).to include("Log out")
  end

  it "rejects invalid credentials" do
    post admin_login_path, params: { username: "admin_test", password: "wrong" }

    expect(response).to have_http_status(:unauthorized)
    expect(response.body).to include("Username or password is incorrect.")
  end

  it "logs out and requires login before accessing admin again" do
    post admin_login_path, params: { username: "admin_test", password: "secret_test" }

    delete admin_logout_path

    expect(response).to redirect_to(admin_login_path)

    follow_redirect!
    expect(response.body).to include("Signed out.")

    get admin_root_path

    expect(response).to redirect_to(admin_login_path)
  end
end
