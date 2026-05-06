module Admin
  class MenuItemsController < BaseController
    before_action :set_menu_item, only: %i[edit update destroy]
    before_action :load_categories, only: %i[new create edit update]

    def index
      @menu_items = MenuItem.includes(:category, photo_attachment: :blob).ordered
    end

    def new
      @menu_item = MenuItem.new(active: true)
    end

    def create
      @menu_item = MenuItem.new(menu_item_attributes)
      if @menu_item.save
        redirect_to admin_menu_items_path, notice: "Menu item created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      attributes = menu_item_attributes

      if @menu_item.update(attributes)
        @menu_item.photo.purge if remove_photo_requested? && attributes[:photo].blank?
        redirect_to admin_menu_items_path, notice: "Menu item updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @menu_item.destroy
      redirect_to admin_menu_items_path, notice: "Menu item removed."
    rescue ActiveRecord::DeleteRestrictionError
      redirect_to admin_menu_items_path, alert: "Cannot delete a menu item used by orders."
    end

    private

    def set_menu_item
      @menu_item = MenuItem.find(params[:id])
    end

    def load_categories
      @categories = Category.ordered
    end

    def menu_item_attributes
      params.require(:menu_item).permit(
        :category_id,
        :name,
        :description,
        :price_cents,
        :active,
        :spicy,
        :vegetarian,
        :gluten_free,
        :image_url,
        :photo,
        :remove_photo,
        :position
      ).except(:remove_photo)
    end

    def remove_photo_requested?
      ActiveModel::Type::Boolean.new.cast(params.dig(:menu_item, :remove_photo))
    end
  end
end
