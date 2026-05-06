require "csv"

module Admin
  class BookingsController < BaseController
    before_action :set_booking, only: %i[show update]

    def index
      @bookings = Booking.recent
      @bookings = @bookings.where(status: params[:status]) if params[:status].present?
    end

    def show; end

    def update
      if @booking.update(booking_params)
        redirect_to admin_booking_path(@booking), notice: "Booking updated."
      else
        render :show, status: :unprocessable_entity
      end
    end

    def export
      bookings = Booking.recent

      send_data build_csv(bookings),
                filename: "bookings-#{Time.zone.today}.csv",
                type: "text/csv"
    end

    private

    def set_booking
      @booking = Booking.find(params[:id])
    end

    def booking_params
      params.require(:booking).permit(:status)
    end

    def build_csv(bookings)
      CSV.generate(headers: true) do |csv|
        csv << %w[id created_at booking_time status name email phone party_size notes]
        bookings.each do |booking|
          csv << [
            booking.id,
            booking.created_at.iso8601,
            booking.booking_time.iso8601,
            booking.status,
            booking.name,
            booking.email,
            booking.phone,
            booking.party_size,
            booking.notes
          ]
        end
      end
    end
  end
end
