require "csv"

module Admin
  class OrdersController < BaseController
    before_action :set_order, only: %i[show update]

    def index
      @orders = Order.includes(order_items: :menu_item).recent
      @orders = @orders.where(status: params[:status]) if params[:status].present?
    end

    def show; end

    def update
      if @order.update(order_params)
        redirect_to admin_order_path(@order), notice: "Order updated."
      else
        render :show, status: :unprocessable_entity
      end
    end

    def export
      orders = Order.includes(order_items: :menu_item).recent

      send_data build_csv(orders),
                filename: "orders-#{Time.zone.today}.csv",
                type: "text/csv"
    end

    private

    def set_order
      @order = Order.includes(order_items: :menu_item).find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status, :paid)
    end

    def build_csv(orders)
      CSV.generate(headers: true) do |csv|
        csv << %w[id public_id created_at status order_type customer_name customer_email customer_phone pickup_time total_cents paid items]
        orders.each do |order|
          csv << [
            order.id,
            order.public_id,
            order.created_at.iso8601,
            order.status,
            order.order_type,
            order.customer_name,
            order.customer_email,
            order.customer_phone,
            order.pickup_time&.iso8601,
            order.total_cents,
            order.paid,
            order.order_items.sum(:quantity)
          ]
        end
      end
    end
  end
end
