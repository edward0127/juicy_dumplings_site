setting = BusinessSetting.current
setting.update!(
  business_name: "Juicy Dumplings",
  suburb: "Doncaster East, VIC",
  address: "2/261 Blackburn Rd, Doncaster East VIC 3109",
  phone: setting.phone.presence || "0425 112 889",
  email: setting.email.presence || "hello@juicydumplings.example",
  owner_email: setting.owner_email.presence || ENV["OWNER_EMAIL"],
  hours_note: "Update opening hours in Admin > Opening Hours",
  ordering_enabled: true,
  pay_at_pickup_enabled: true,
  slot_interval_minutes: 30,
  max_bookings_per_slot: 8,
  price_range: "$$"
)

opening_hours_data = [
  [0, "11:00", "21:00", false],
  [1, "11:00", "21:00", false],
  [2, "11:00", "21:00", false],
  [3, "11:00", "21:00", false],
  [4, "11:00", "21:30", false],
  [5, "11:00", "21:30", false],
  [6, "11:00", "21:00", false]
]

opening_hours_data.each do |day, open, close, closed|
  hour = OpeningHour.find_or_initialize_by(day_of_week: day)
  hour.update!(opens_at: open, closes_at: close, closed: closed)
end

seed_asset_root = Rails.root.join("db/seed_assets/menu_items")
force_menu_images = ActiveModel::Type::Boolean.new.cast(ENV["RESEED_MENU_IMAGES"])

# Fixed seed images do not need Active Storage analyzer jobs during db:seed.
ActiveJob::Base.queue_adapter = :test

attach_seed_photo = lambda do |menu_item, filename|
  return if filename.blank?

  path = seed_asset_root.join(filename)
  unless path.exist?
    warn "Seed image missing for #{menu_item.name}: #{path}"
    return
  end

  return if menu_item.photo.attached? && !force_menu_images

  menu_item.photo.purge if menu_item.photo.attached?
  path.open("rb") do |file|
    menu_item.photo.attach(
      io: file,
      filename: filename,
      content_type: "image/jpeg",
      identify: false
    )
  end
end

menu_seed = {
  "A La Carte" => [
    { name: "Wuxi Juicy Dumpling", description: "Steamed Wuxi-style juicy dumplings, 4 pieces per basket.", price_cents: 680, spicy: false, vegetarian: false, gluten_free: false, photo: "wuxi_juicy_dumpling.jpg" },
    { name: "Shanghai Juicy Dumpling", description: "Steamed Shanghai-style juicy dumplings, 4 pieces per basket.", price_cents: 680, spicy: false, vegetarian: false, gluten_free: false, photo: "shanghai_juicy_dumpling.jpg" },
    { name: "Mini Pork Wonton", description: "Mini pork wontons, 25 pieces per bowl. Choose clear soup, red soup, or dry mixed.", price_cents: 1280, spicy: false, vegetarian: false, gluten_free: false, photo: "mini_pork_wonton.jpg" },
    { name: "Shepherd's Purse & Pork Jumbo Wonton", description: "Jumbo wontons with shepherd's purse and pork, 8 pieces per bowl. Choose clear soup, red soup, or dry mixed.", price_cents: 1280, spicy: false, vegetarian: false, gluten_free: false, photo: "shepherds_purse_pork_jumbo_wonton.jpg" },
    { name: "Prawn, Vege & Pork Jumbo Wonton", description: "Jumbo wontons with prawn, vegetables, and pork, 8 pieces per bowl. Choose clear soup, red soup, or dry mixed.", price_cents: 1380, spicy: false, vegetarian: false, gluten_free: false, photo: "prawn_vege_pork_jumbo_wonton.jpg" },
    { name: "Dried Shrimp & Pork Wonton", description: "Dried shrimp and pork wontons, 10 pieces per bowl.", price_cents: 1380, spicy: false, vegetarian: false, gluten_free: false, photo: "dried_shrimp_pork_wonton.jpg" }
  ],
  "Set Meals" => [
    { name: "Set A: Wuxi Juicy Dumpling + Mini Pork Wonton + Tea Egg", description: "Wuxi juicy dumplings, mini pork wontons, and a tea egg.", price_cents: 2000, spicy: false, vegetarian: false, gluten_free: false, photo: "wuxi_juicy_dumpling.jpg" },
    { name: "Set B: Shanghai Juicy Dumpling + Mini Pork Wonton + Tea Egg", description: "Shanghai juicy dumplings, mini pork wontons, and a tea egg.", price_cents: 2000, spicy: false, vegetarian: false, gluten_free: false, photo: "shanghai_juicy_dumpling.jpg" },
    { name: "Set C: Shepherd's Purse & Pork Jumbo Wonton + Tea Egg", description: "Shepherd's purse and pork jumbo wontons with a tea egg. Choose soup or dry.", price_cents: 1380, spicy: false, vegetarian: false, gluten_free: false, photo: "shepherds_purse_pork_jumbo_wonton.jpg" },
    { name: "Set D: Prawn, Vege & Pork Jumbo Wonton + Tea Egg", description: "Prawn, vegetable, and pork jumbo wontons with a tea egg. Choose soup or dry.", price_cents: 1480, spicy: false, vegetarian: false, gluten_free: false, photo: "prawn_vege_pork_jumbo_wonton.jpg" },
    { name: "Set E: Wuxi Juicy Dumpling + Dried Shrimp & Pork Wonton", description: "Wuxi juicy dumplings with dried shrimp and pork wontons. Choose soup or dry.", price_cents: 1880, spicy: false, vegetarian: false, gluten_free: false, photo: "dried_shrimp_pork_wonton.jpg" },
    { name: "Set F: Chongming Rice Cake + Mini Pork Wonton + Tea Egg", description: "Chongming rice cake, mini pork wontons, and a tea egg.", price_cents: 2380, spicy: false, vegetarian: false, gluten_free: false, photo: "chongming_rice_cake.jpg" }
  ],
  "Sides" => [
    { name: "Tea Egg", description: "Braised tea egg.", price_cents: 250, spicy: false, vegetarian: true, gluten_free: false, photo: "tea_egg.jpg" },
    { name: "Spring Rolls", description: "Crisp spring rolls, 2 pieces.", price_cents: 500, spicy: false, vegetarian: false, gluten_free: false, photo: "spring_rolls.jpg" },
    { name: "Chongming Rice Cake", description: "Chongming rice cake.", price_cents: 1150, spicy: false, vegetarian: false, gluten_free: false, photo: "chongming_rice_cake.jpg" }
  ],
  "Pan-Fried Wontons" => [
    { name: "Pan-Fried Shepherd's Purse & Pork Jumbo Wonton", description: "Pan-fried jumbo wontons with shepherd's purse and pork.", price_cents: 1480, spicy: false, vegetarian: false, gluten_free: false, photo: "pan_fried_jumbo_wonton.jpg" },
    { name: "Pan-Fried Prawn, Vege & Pork Jumbo Wonton", description: "Pan-fried jumbo wontons with prawn, vegetables, and pork.", price_cents: 1580, spicy: false, vegetarian: false, gluten_free: false, photo: "pan_fried_jumbo_wonton.jpg" }
  ],
  "Drinks" => [
    { name: "Soft Drink / Wang Lao Ji", description: "Soft drink or Wang Lao Ji herbal tea.", price_cents: 300, spicy: false, vegetarian: true, gluten_free: true, photo: "soft_drink_wang_lao_ji.jpg" },
    { name: "Soy Milk", description: "Soy milk.", price_cents: 450, spicy: false, vegetarian: true, gluten_free: true, photo: "soy_milk.jpg" }
  ]
}

real_category_names = menu_seed.keys
real_item_names = menu_seed.values.flatten.map { |item| item[:name] }

Category.where.not(name: real_category_names).update_all(active: false, updated_at: Time.current)
MenuItem.where.not(name: real_item_names).update_all(active: false, updated_at: Time.current)

menu_seed.each_with_index do |(category_name, items), category_index|
  category = Category.find_or_initialize_by(name: category_name)
  category.update!(position: category_index, active: true)

  items.each_with_index do |item_data, item_index|
    menu_item = MenuItem.where(name: item_data[:name]).order(:id).first_or_initialize
    photo_filename = item_data[:photo]
    menu_item.assign_attributes(item_data.except(:photo).merge(active: true, position: item_index))
    menu_item.category = category
    menu_item.save!
    MenuItem.where(name: item_data[:name]).where.not(id: menu_item.id).update_all(active: false, updated_at: Time.current)
    attach_seed_photo.call(menu_item, photo_filename)
  end
end

puts "Seeded Juicy Dumplings data."
