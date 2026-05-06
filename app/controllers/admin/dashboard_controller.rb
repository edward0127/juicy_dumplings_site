module Admin
  class DashboardController < BaseController
    def index
      @orders_today = Order.where(created_at: Time.zone.today.all_day).count
      @bookings_today = Booking.where(booking_time: Time.zone.today.all_day).count
      @pending_orders = Order.where(status: %i[new confirmed in_kitchen]).recent.limit(10)
      @pending_bookings = Booking.where(status: %i[pending confirmed]).recent.limit(10)
    end
  end
end
