require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  it "uses recipient and email contact as reply-to" do
    mail = described_class.contact_message(
      {
        name: "Taylor",
        contact: "taylor@example.com",
        message: "Do you take group bookings?"
      },
      "owner@example.com"
    )

    expect(mail.to).to eq(["owner@example.com"])
    expect(mail.reply_to).to eq(["taylor@example.com"])
    expect(mail.subject).to eq("New website contact message")
    expect(mail.body.encoded).to include("Taylor")
    expect(mail.body.encoded).to include("Do you take group bookings?")
  end

  it "does not set reply-to when contact is not an email address" do
    mail = described_class.contact_message(
      {
        name: "Taylor",
        contact: "0400000000",
        message: "Please call me back."
      },
      "owner@example.com"
    )

    expect(mail.to).to eq(["owner@example.com"])
    expect(mail.reply_to).to be_nil
  end
end
