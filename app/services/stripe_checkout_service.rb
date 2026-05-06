class StripeCheckoutService
  CURRENCY = "aud".freeze

  def initialize(order)
    @order = order
  end

  def create_session(success_url:, cancel_url:)
    Stripe::Checkout::Session.create(
      mode: "payment",
      payment_method_types: ["card"],
      line_items: stripe_line_items,
      customer_email: @order.customer_email.presence,
      success_url: success_url,
      cancel_url: cancel_url,
      metadata: {
        order_public_id: @order.public_id
      }
    )
  end

  def retrieve_session(session_id)
    Stripe::Checkout::Session.retrieve(session_id)
  end

  private

  def stripe_line_items
    @order.order_items.map do |item|
      {
        quantity: item.quantity,
        price_data: {
          currency: CURRENCY,
          unit_amount: item.unit_price_cents,
          product_data: {
            name: item.menu_item.name,
            description: item.menu_item.description.to_s.first(120)
          }
        }
      }
    end
  end
end
