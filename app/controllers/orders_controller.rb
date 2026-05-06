class OrdersController < ApplicationController
  before_action :ensure_ordering_enabled!, only: %i[new create]
  before_action :load_order, only: %i[show success]

  def new
    @order = Order.new(order_type: :pickup, pickup_time: default_pickup_time)
    load_order_page_data
    set_page_metadata(
      title: "Order Online | Juicy Dumplings",
      description: "Order Juicy Dumplings online for pickup or delivery request in Doncaster East."
    )
  end

  def create
    if cart.empty?
      redirect_to order_path, alert: "Your cart is empty."
      return
    end

    @order = build_order_from_cart

    if checkout_now? && !stripe_configured?
      @order.errors.add(:base, "Online payment is temporarily unavailable. Please try again shortly.")
      load_order_page_data
      render :new, status: :unprocessable_entity
      return
    end

    if @order.save
      cart.clear

      if checkout_now?
        session = StripeCheckoutService.new(@order).create_session(
          success_url: order_success_url(@order.public_id, session_id: "{CHECKOUT_SESSION_ID}"),
          cancel_url: order_path
        )
        @order.update!(stripe_session_id: session.id)
        redirect_to session.url, allow_other_host: true
      else
        finalize_order(@order)
        redirect_to order_confirmation_path(@order.public_id), notice: "Order placed successfully."
      end
    else
      load_order_page_data
      render :new, status: :unprocessable_entity
    end
  rescue Stripe::StripeError => e
    @order.errors.add(:base, "Payment setup failed: #{e.message}")
    load_order_page_data
    render :new, status: :unprocessable_entity
  end

  def show
    set_page_metadata(
      title: "Order Confirmation | Juicy Dumplings",
      description: "Your Juicy Dumplings order has been received."
    )
  end

  def success
    if params[:session_id].present? && stripe_configured? && !@order.paid?
      stripe_session = StripeCheckoutService.new(@order).retrieve_session(params[:session_id])
      if stripe_session.payment_status == "paid"
        @order.update!(paid: true)
        finalize_order(@order)
      end
    end

    redirect_to order_confirmation_path(@order.public_id)
  rescue Stripe::StripeError
    redirect_to order_confirmation_path(@order.public_id), alert: "Payment confirmation is pending."
  end

  private

  def ensure_ordering_enabled!
    return if business_setting.ordering_enabled?

    redirect_to root_path, alert: "Online ordering is currently disabled."
  end

  def load_order
    @order = Order.includes(order_items: :menu_item).find_by!(public_id: params[:public_id])
  end

  def load_order_page_data
    @categories = Category.active.ordered.includes(menu_items: { photo_attachment: :blob })
    @selected_pickup_date = selected_pickup_date
    @available_pickup_slots = available_pickup_slots(@selected_pickup_date)
  end

  def build_order_from_cart
    order = Order.new(order_params.except(:payment_method))

    cart.line_items.each do |line_item|
      order.order_items.build(
        menu_item: line_item.menu_item,
        quantity: line_item.quantity,
        unit_price_cents: line_item.menu_item.price_cents
      )
    end

    order
  end

  def order_params
    params.require(:order).permit(
      :customer_name,
      :customer_phone,
      :customer_email,
      :order_type,
      :pickup_time,
      :delivery_address,
      :notes,
      :payment_method
    )
  end

  def checkout_now?
    return true unless business_setting.pay_at_pickup_enabled?

    order_params[:payment_method] == "pay_now"
  end

  def stripe_configured?
    ENV["STRIPE_SECRET_KEY"].present?
  end

  def finalize_order(order)
    should_notify = order.status_new?
    order.update!(status: :confirmed)

    return unless should_notify

    NotificationsMailer.order_confirmation(order).deliver_later if order.customer_email.present?
    owner_email = business_setting.owner_notification_email
    NotificationsMailer.owner_new_order(order, owner_email).deliver_later if owner_email.present?
    SmsNotifier.notify_owner("New order #{order.public_id} for #{order.customer_name}") if owner_email.present?
  end

  def selected_pickup_date
    Date.parse(params[:pickup_date])
  rescue StandardError
    Time.zone.today
  end

  def available_pickup_slots(date)
    opening_hour = OpeningHour.for_time(date.in_time_zone)
    return [] if opening_hour.nil?

    opening_hour.slot_times_for(date, business_setting.slot_interval_minutes).select { |slot| slot > Time.current }
  end

  def default_pickup_time
    available_pickup_slots(Time.zone.today).first || (Time.current + 45.minutes)
  end
end
