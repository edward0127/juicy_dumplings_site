require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#active_storage_public_url" do
    around do |example|
      original_asset_host = ENV["PUBLIC_UPLOAD_ASSET_HOST"]
      example.run
    ensure
      ENV["PUBLIC_UPLOAD_ASSET_HOST"] = original_asset_host
    end

    it "uses PUBLIC_UPLOAD_ASSET_HOST for amazon blobs" do
      ENV["PUBLIC_UPLOAD_ASSET_HOST"] = "https://images.example.cloudfront.net/"
      blob = instance_double(ActiveStorage::Blob, service_name: "amazon", key: "abc123/photo.jpg")
      attachment = double("attachment", attached?: true, blob: blob)

      expect(helper.active_storage_public_url(attachment)).to eq("https://images.example.cloudfront.net/abc123/photo.jpg")
    end

    it "keeps local blobs on normal Rails Active Storage URLs" do
      ENV["PUBLIC_UPLOAD_ASSET_HOST"] = "https://images.example.cloudfront.net"
      blob = instance_double(ActiveStorage::Blob, service_name: "local", key: "abc123/photo.jpg")
      attachment = double("attachment", attached?: true, blob: blob)

      allow(helper).to receive(:url_for).with(attachment).and_return("/rails/active_storage/blobs/redirect/local-key/photo.jpg")

      expect(helper.active_storage_public_url(attachment)).to eq("/rails/active_storage/blobs/redirect/local-key/photo.jpg")
    end

    it "returns nil for missing attachments" do
      expect(helper.active_storage_public_url(nil)).to be_nil
    end
  end
end
