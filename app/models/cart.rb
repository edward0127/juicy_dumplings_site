class Cart
  LineItem = Struct.new(:menu_item, :quantity, keyword_init: true) do
    def total_cents
      menu_item.price_cents * quantity
    end
  end

  def initialize(session)
    @session = session
    @session[:cart] ||= {}
  end

  def add(menu_item_id, quantity = 1)
    key = menu_item_id.to_s
    @session[:cart][key] = @session[:cart].fetch(key, 0).to_i + quantity.to_i
  end

  def update(menu_item_id, quantity)
    key = menu_item_id.to_s
    qty = quantity.to_i
    if qty <= 0
      @session[:cart].delete(key)
    else
      @session[:cart][key] = qty
    end
  end

  def remove(menu_item_id)
    @session[:cart].delete(menu_item_id.to_s)
  end

  def clear
    @session[:cart] = {}
  end

  def quantity_for(menu_item_id)
    @session[:cart].fetch(menu_item_id.to_s, 0).to_i
  end

  def count
    @session[:cart].values.map(&:to_i).sum
  end

  def empty?
    @session[:cart].blank?
  end

  def line_items
    items_by_id = MenuItem.where(id: item_ids).index_by(&:id)

    cart_data.filter_map do |key, quantity|
      menu_item = items_by_id[key.to_i]
      next if menu_item.nil?

      LineItem.new(menu_item: menu_item, quantity: quantity.to_i)
    end
  end

  def subtotal_cents
    line_items.sum(&:total_cents)
  end

  private

  def cart_data
    @session[:cart] || {}
  end

  def item_ids
    cart_data.keys
  end
end
