class SeoController < ApplicationController
  def sitemap
    @static_paths = [root_path, menu_path, order_path, book_path, about_path, contact_path, privacy_path, terms_path]
    expires_in 12.hours, public: true
  end

  def robots
    render plain: <<~ROBOTS
      User-agent: *
      Allow: /

      Sitemap: #{sitemap_url}
    ROBOTS
  end
end
