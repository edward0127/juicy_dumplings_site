class BookingsController < ApplicationController
  before_action :set_booking_form_context, only: %i[new create]
  before_action :load_booking, only: :show

  def new
    @booking = Booking.new(booking_time: @available_slots.first)
    set_page_metadata(
      title: "Book a Table | Juicy Dumplings",
      description: "Book a table at Juicy Dumplings in Doncaster East with live time slots."
    )
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      NotificationsMailer.booking_confirmation(@booking).deliver_later if @booking.email.present?
      owner_email = business_setting.owner_notification_email
      NotificationsMailer.owner_new_booking(@booking, owner_email).deliver_later if owner_email.present?
      SmsNotifier.notify_owner("New booking ##{@booking.id} for #{@booking.name}") if owner_email.present?
      redirect_to booking_confirmation_path(@booking), notice: "Booking request received."
    else
      @selected_date = @booking.booking_time&.to_date || @selected_date
      @available_slots = Booking.available_slots_for(@selected_date)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    set_page_metadata(
      title: "Booking Confirmation | Juicy Dumplings",
      description: "Your booking request has been received by Juicy Dumplings."
    )
  end

  def slots
    date = parse_date(params[:date])
    slots = Booking.available_slots_for(date).select { |slot| slot > Time.current }

    render json: {
      slots: slots.map { |slot| { value: slot.iso8601, label: slot.strftime("%I:%M %p") } }
    }
  end

  private

  def load_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:name, :phone, :email, :party_size, :booking_time, :notes)
  end

  def set_booking_form_context
    @selected_date = parse_date(params[:date] || params.dig(:booking, :booking_time))
    @available_slots = Booking.available_slots_for(@selected_date).select { |slot| slot > Time.current }
  end

  def parse_date(value)
    parsed = Time.zone.parse(value.to_s)
    parsed&.to_date || Time.zone.today
  rescue StandardError
    Time.zone.today
  end
end
