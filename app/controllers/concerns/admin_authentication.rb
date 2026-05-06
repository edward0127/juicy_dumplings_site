module AdminAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_admin!
  end

  private

  def authenticate_admin!
    authenticate_or_request_with_http_basic("Admin") do |username, password|
      secure_compare(username, ENV.fetch("ADMIN_USER", "admin")) &&
        secure_compare(password, ENV.fetch("ADMIN_PASS", "change_me"))
    end
  end

  def secure_compare(value, expected)
    ActiveSupport::SecurityUtils.secure_compare(
      Digest::SHA256.hexdigest(value.to_s),
      Digest::SHA256.hexdigest(expected.to_s)
    )
  end
end
