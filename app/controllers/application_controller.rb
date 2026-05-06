class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :load_business_setting

  helper_method :business_setting, :cart

  private

  def load_business_setting
    @business_setting = BusinessSetting.current
  end

  def business_setting
    @business_setting
  end

  def cart
    @cart ||= Cart.new(session)
  end

  def set_page_metadata(title:, description:)
    @page_title = title
    @page_description = description
  end
end
