require "net/http"
require "uri"

class SmsNotifier
  def self.notify_owner(message)
    webhook_url = ENV["SMS_WEBHOOK_URL"].to_s
    return if webhook_url.blank?

    uri = URI.parse(webhook_url)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = { message: message }.to_json

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
  rescue StandardError => error
    Rails.logger.warn("SMS hook failed: #{error.class} #{error.message}")
  end
end
