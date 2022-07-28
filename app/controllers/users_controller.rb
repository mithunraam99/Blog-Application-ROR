class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  before_action :require_user, only: [:show, :index]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image.attach(params[:user][:image])

    if @user.save
      session[:user_id] = @user.id
      cookies.signed[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.username} to the Blog App!"
      redirect_to user_path(@user)
    else
      render "new"
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
    @saved = Article.joins(:bookmarks).where("bookmarks.user_id=?", current_user.id).
      includes(:likes, :comments) if @user == current_user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "#{@user.username} was updated successfully!"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      flash[:danger] = "User and all associated articles have been deleted"
      redirect_to users_path
    else
      flash[:danger] = "ERROR"
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :image, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit or delete your own account"
      redirect_to users_path
    end
  end

  def require_admin
    if logged_in? && !current_user.admin?
      flash[:danger] = "Only admin users can perform that action"
      redirect_to root_path
    end
  end
end
