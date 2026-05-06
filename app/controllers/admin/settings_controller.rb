module Admin
  class SettingsController < BaseController
    def edit
      @setting = BusinessSetting.current
    end

    def update
      @setting = BusinessSetting.current
      if @setting.update(setting_params)
        redirect_to edit_admin_settings_path, notice: "Settings updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def setting_params
      params.require(:business_setting).permit(
        :business_name,
        :suburb,
        :address,
        :phone,
        :email,
        :owner_email,
        :hours_note,
        :price_range,
        :ordering_enabled,
        :pay_at_pickup_enabled,
        :slot_interval_minutes,
        :max_bookings_per_slot
      )
    end
  end
end
