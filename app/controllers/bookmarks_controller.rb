class BookmarksController < ApplicationController
  before_action :require_user
  before_action :validate_user, only: :index

  def index
    user = User.find(params[:user_id])
    @articles = Article.joins(:bookmarks).where("bookmarks.user_id=?", current_user.id).includes(:likes, :comments) 
    render "bookmarks/index", locals: {articles: @articles} 
  end

  def create
    @bookmark = current_user.bookmarks.build(bookmark_params)
    if @bookmark.save
      @article = @bookmark.article
      @is_bookmarked = @bookmark
      respond_to :js
    else
      flash[:danger] = "Something went wrong ..."
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @article = @bookmark.article
    if @bookmark.destroy
      respond_to :js
    else
      flash[:danger] = "Something went wrong ..."
    end
  end

  private
  def bookmark_params
    params.permit :user_id, :article_id
  end

  def validate_user
    unless params[:user_id].to_i == current_user.id
      flash[:danger] = "Invalid user"
      redirect_to user_bookmarks_path(current_user.id)
    end
  end
end
