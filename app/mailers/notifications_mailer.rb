class NotificationsMailer < ApplicationMailer
  def order_confirmation(order)
    @order = order
    mail(to: order.customer_email, subject: "Your Juicy Dumplings order #{@order.public_id}")
  end

  def owner_new_order(order, recipient)
    @order = order
    mail(to: recipient, subject: "New order #{@order.public_id}")
  end

  def booking_confirmation(booking)
    @booking = booking
    mail(to: booking.email, subject: "Your Juicy Dumplings booking request")
  end

  def owner_new_booking(booking, recipient)
    @booking = booking
    mail(to: recipient, subject: "New booking request ##{@booking.id}")
  end

  def contact_message(contact_payload, recipient)
    @contact_message = contact_payload.with_indifferent_access

    mail_options = {
      to: recipient,
      subject: "New website contact message"
    }

    contact_value = @contact_message[:contact].to_s.strip
    mail_options[:reply_to] = contact_value if contact_value.match?(/\A[^@\s]+@[^@\s]+\.[^@\s]+\z/)

    mail(**mail_options)
  end
end
