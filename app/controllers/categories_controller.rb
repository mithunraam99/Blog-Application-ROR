class CategoriesController < ApplicationController
  before_action :require_admin, except: [:show, :index]
  
  
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category was successfully created"
      redirect_to @category
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:notice] = "Category name updated successfully"
      redirect_to @category
    else
      render 'edit'
    end
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def show
    @category = Category.find(params[:id])
    @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:danger] = "Selected Category have been deleted"
      redirect_to @category
    else
      flash[:danger] = "ERROR"
    end
  end
  
  private

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !(logged_in? && current_user.admin?)
      flash[:alert] = "Only admins can perform that action"
      redirect_to categories_path
    end
  end
  
end