class CartItemsController < ApplicationController
  before_action :load_menu_item, only: %i[create update destroy]

  def create
    cart.add(@menu_item.id, params.fetch(:quantity, 1))
    respond_with_cart_update(notice: "Added #{@menu_item.name} to cart")
  end

  def update
    cart.update(@menu_item.id, params.fetch(:quantity, 1))
    respond_with_cart_update
  end

  def destroy
    cart.remove(@menu_item.id)
    respond_with_cart_update
  end

  def clear
    cart.clear
    respond_with_cart_update
  end

  private

  def load_menu_item
    @menu_item = MenuItem.find(params[:menu_item_id])
  end

  def respond_with_cart_update(notice: nil)
    flash.now[:notice] = notice if notice.present?

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "cart_drawer",
            partial: "orders/cart_drawer",
            locals: { cart: cart, business_setting: business_setting }
          ),
          turbo_stream.replace(
            "cart_badge",
            partial: "shared/cart_badge",
            locals: { cart: cart }
          )
        ]
      end
      format.html { redirect_to order_path }
    end
  end
end
