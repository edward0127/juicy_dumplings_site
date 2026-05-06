host = ENV["HOST"].presence

if host
  Rails.application.routes.default_url_options[:host] = host
end
