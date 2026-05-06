module ApplicationHelper
  def money(cents)
    number_to_currency(cents.to_i / 100.0, unit: "$", precision: 2)
  end

  def menu_item_photo_tag(item, classes:, alt: nil)
    alt_text = alt.presence || item&.name || business_setting.business_name

    if item&.photo&.attached?
      image_tag(item.photo, alt: alt_text, class: classes, loading: "lazy", decoding: "async")
    elsif item&.image_url.present?
      image_tag(item.image_url, alt: alt_text, class: classes, loading: "lazy", decoding: "async")
    else
      content_tag(:div, class: "#{classes} flex items-center justify-center bg-[#fff2d6]") do
        content_tag(:span, "JD", class: "brand-mark")
      end
    end
  end

  def rating_text(rating)
    "#{rating.to_i}/5 stars"
  end

  def full_business_address
    address = business_setting.address.to_s
    suburb = business_setting.suburb.to_s
    locality = suburb.split(",").first.to_s.strip

    return address if locality.present? && address.downcase.include?(locality.downcase)

    [address, suburb].compact_blank.join(", ")
  end

  def page_title
    @page_title.presence || "#{business_setting.business_name} | #{business_setting.suburb}"
  end

  def page_description
    @page_description.presence || "Order online, book a table, and explore the menu at #{business_setting.business_name}."
  end

  def nav_link_classes(path)
    base = "rounded-full px-4 py-2 text-sm font-extrabold transition"
    if current_page?(path)
      "#{base} bg-[#f4c84a] text-neutral-950"
    else
      "#{base} text-neutral-700 hover:bg-white"
    end
  end

  def admin_nav_link_classes(path)
    base = "rounded-full px-3 py-2 text-sm font-extrabold transition"
    if current_page?(path)
      "#{base} bg-[#f4c84a] text-neutral-950"
    else
      "#{base} bg-white/10 text-white hover:bg-white/20"
    end
  end

  def menu_category_blurb(category_name)
    {
      "A La Carte" => "Choose your dumplings or wontons by the bowl or basket.",
      "Set Meals" => "Easy combinations for lunch, dinner, or sharing.",
      "Sides" => "Small plates and simple extras for the table.",
      "Pan-Fried Wontons" => "Golden-bottom wontons with a crisp finish.",
      "Drinks" => "Cold drinks to go with a warm dumpling meal."
    }[category_name.to_s]
  end

  def order_status_badge(status)
    css = case status.to_s
          when "new" then "bg-sky-100 text-sky-700"
          when "confirmed" then "bg-blue-100 text-blue-700"
          when "in_kitchen" then "bg-orange-100 text-orange-700"
          when "completed" then "bg-emerald-100 text-emerald-700"
          when "cancelled" then "bg-rose-100 text-rose-700"
          else "bg-neutral-100 text-neutral-700"
          end

    content_tag(:span, status.to_s.humanize, class: "rounded-full px-3 py-1 text-xs font-semibold #{css}")
  end

  def booking_status_badge(status)
    css = case status.to_s
          when "pending" then "bg-yellow-100 text-yellow-700"
          when "confirmed" then "bg-emerald-100 text-emerald-700"
          when "cancelled" then "bg-rose-100 text-rose-700"
          when "no_show" then "bg-neutral-200 text-neutral-700"
          else "bg-neutral-100 text-neutral-700"
          end

    content_tag(:span, status.to_s.humanize, class: "rounded-full px-3 py-1 text-xs font-semibold #{css}")
  end

  def opening_hours_summary
    if business_setting.hours_note.present?
      business_setting.hours_note
    else
      "Please check with staff for current trading hours."
    end
  end

  def opening_hours_lines
    hours = OpeningHour.ordered
    return [opening_hours_summary] if hours.empty?

    hours.map do |hour|
      if hour.closed?
        "#{hour.day_name}: Closed"
      else
        "#{hour.day_name}: #{hour.opens_at} - #{hour.closes_at}"
      end
    end
  end

  def restaurant_json_ld
    {
      "@context" => "https://schema.org",
      "@type" => "Restaurant",
      name: business_setting.business_name,
      address: {
        "@type" => "PostalAddress",
        streetAddress: business_setting.address,
        addressLocality: business_setting.suburb,
        addressRegion: "VIC",
        postalCode: "3109",
        addressCountry: "AU"
      },
      telephone: business_setting.phone.presence || "",
      email: business_setting.email.presence || "",
      priceRange: business_setting.price_range,
      servesCuisine: ["Chinese", "Dumplings"],
      url: request.base_url,
      openingHours: opening_hours_lines
    }.to_json
  end
end
