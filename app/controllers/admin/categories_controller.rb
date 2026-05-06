module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: %i[edit update destroy]

    def index
      @categories = Category.ordered
    end

    def new
      @category = Category.new(active: true)
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Category created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: "Category removed."
    rescue ActiveRecord::DeleteRestrictionError
      redirect_to admin_categories_path, alert: "Cannot delete a category with menu items."
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :position, :active)
    end
  end
end
