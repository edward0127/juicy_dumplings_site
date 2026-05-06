class PagesController < ApplicationController
  before_action :load_menu_categories, only: %i[home menu]

  SIGNATURE_ITEM_NAMES = [
    "Wuxi Juicy Dumpling",
    "Mini Pork Wonton",
    "Dried Shrimp & Pork Wonton"
  ].freeze

  POPULAR_ITEM_NAMES = [
    "Wuxi Juicy Dumpling",
    "Shepherd's Purse & Pork Jumbo Wonton",
    "Spring Rolls",
    "Tea Egg"
  ].freeze

  def home
    @signature_items = ordered_menu_items(SIGNATURE_ITEM_NAMES)
    @signature_items = MenuItem.active.ordered.with_attached_photo.limit(3).to_a if @signature_items.empty?
    @popular_items = ordered_menu_items(POPULAR_ITEM_NAMES)
    @popular_items = @signature_items if @popular_items.empty?
    @hero_item = @signature_items.first || MenuItem.active.ordered.with_attached_photo.first
    @reviews = [
      { author: "Local Guide", quote: "Fresh dumplings, fast service, and consistent quality.", rating: 5 },
      { author: "Family Visitor", quote: "A warm little spot for quick family dinners and takeaway.", rating: 5 },
      { author: "Regular", quote: "The wonton soup is comforting, generous, and always reliable.", rating: 5 }
    ]

    set_page_metadata(
      title: "Juicy Dumplings | Doncaster East",
      description: "Juicy Dumplings in Doncaster East, VIC. View menu, order online for pickup, and book a table."
    )
  end

  def menu
    set_page_metadata(
      title: "Menu | Juicy Dumplings",
      description: "Explore dumplings, noodles, soups, and sides with dietary tags."
    )
  end

  def about
    set_page_metadata(
      title: "About | Juicy Dumplings",
      description: "A neighborhood dumpling kitchen serving handmade comfort food in Doncaster East."
    )
  end

  def contact
    @contact_form = ContactMessageForm.new

    set_page_metadata(
      title: "Contact | Juicy Dumplings",
      description: "Contact Juicy Dumplings for enquiries, catering, and trading hour updates."
    )
  end

  def privacy
    set_page_metadata(
      title: "Privacy Policy | Juicy Dumplings",
      description: "Privacy policy for Juicy Dumplings online orders and bookings."
    )
  end

  def terms
    set_page_metadata(
      title: "Terms | Juicy Dumplings",
      description: "Terms and conditions for orders, bookings, and website usage."
    )
  end

  private

  def load_menu_categories
    @categories = Category.active.ordered.includes(menu_items: { photo_attachment: :blob })
  end

  def ordered_menu_items(names)
    items_by_name = MenuItem.active.with_attached_photo.where(name: names).index_by(&:name)
    names.filter_map { |name| items_by_name[name] }
  end
end
