require "rails_helper"

RSpec.describe "Contact messages", type: :request do
  include ActiveJob::TestHelper

  before do
    clear_enqueued_jobs
    BusinessSetting.current.update!(
      email: "shop@example.com",
      owner_email: "owner@example.com"
    )
  end

  after do
    clear_enqueued_jobs
  end

  it "enqueues a contact email with serializable payload and owner recipient" do
    expect do
      expect do
        post contact_path, params: {
          contact_message_form: {
            name: "Taylor",
            contact: "taylor@example.com",
            message: "Do you take group bookings?",
            website: ""
          }
        }
      end.not_to raise_error
    end.to have_enqueued_mail(NotificationsMailer, :contact_message).with(
      {
        name: "Taylor",
        contact: "taylor@example.com",
        message: "Do you take group bookings?"
      },
      "owner@example.com"
    )

    expect(response).to redirect_to(contact_path)
  end
end
