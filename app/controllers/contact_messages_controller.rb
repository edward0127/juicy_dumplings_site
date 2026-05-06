class ContactMessagesController < ApplicationController
  def create
    @contact_form = ContactMessageForm.new(contact_message_params)

    if @contact_form.spam?
      redirect_to contact_path, notice: "Thanks for your message."
      return
    end

    if @contact_form.valid?
      owner_email = business_setting.owner_notification_email
      contact_payload = {
        name: @contact_form.name,
        contact: @contact_form.contact,
        message: @contact_form.message
      }
      NotificationsMailer.contact_message(contact_payload, owner_email).deliver_later if owner_email.present?
      redirect_to contact_path, notice: "Thanks. We will get back to you soon."
    else
      set_page_metadata(
        title: "Contact | Juicy Dumplings",
        description: "Contact Juicy Dumplings for enquiries, catering, and trading hour updates."
      )
      render "pages/contact", status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.require(:contact_message_form).permit(:name, :contact, :message, :website)
  end
end
