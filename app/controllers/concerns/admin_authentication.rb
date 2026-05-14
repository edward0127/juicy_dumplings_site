module AdminAuthentication
  extend ActiveSupport::Concern

  def self.valid_credentials?(username, password)
    secure_compare(username, ENV.fetch("ADMIN_USER", "admin")) &&
      secure_compare(password, ENV.fetch("ADMIN_PASS", "change_me"))
  end

  included do
    before_action :authenticate_admin!
  end

  private

  def authenticate_admin!
    return if session[:admin_authenticated] == true

    session[:admin_return_to] = request.fullpath if request.get?
    redirect_to admin_login_path, alert: "Please sign in to continue."
  end

  def self.secure_compare(value, expected)
    ActiveSupport::SecurityUtils.secure_compare(
      Digest::SHA256.hexdigest(value.to_s),
      Digest::SHA256.hexdigest(expected.to_s)
    )
  end

  private_class_method :secure_compare
end
