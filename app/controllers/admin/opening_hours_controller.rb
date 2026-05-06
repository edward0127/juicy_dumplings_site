module Admin
  class OpeningHoursController < BaseController
    before_action :set_opening_hour, only: %i[edit update destroy]

    def index
      @opening_hours = OpeningHour.ordered
    end

    def new
      @opening_hour = OpeningHour.new(closed: false)
    end

    def create
      @opening_hour = OpeningHour.new(opening_hour_params)
      if @opening_hour.save
        redirect_to admin_opening_hours_path, notice: "Opening hour created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @opening_hour.update(opening_hour_params)
        redirect_to admin_opening_hours_path, notice: "Opening hour updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @opening_hour.destroy
      redirect_to admin_opening_hours_path, notice: "Opening hour removed."
    end

    private

    def set_opening_hour
      @opening_hour = OpeningHour.find(params[:id])
    end

    def opening_hour_params
      params.require(:opening_hour).permit(:day_of_week, :opens_at, :closes_at, :closed)
    end
  end
end
