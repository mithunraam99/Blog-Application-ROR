class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :like]
  before_action :require_user, except: [:index, :show, :like]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_user_like, only: [:like]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def search
    @articles = Article.where("name Like ?", "%" + params[:q].to_s + "%")
  end

  def new
    @article = Article.new
  end

  def create
    
    @article = Article.new(article_params)
    # @article.image.attach(params[:article][:image]) if params[:article][:image].present?
    @article.user = current_user
        
    if @article.save
      flash[:success] = "Article was created successfully!"
      redirect_to article_path(@article)
    else
      render "new"
    end
  end

  def show
    @comment = Comment.new
    @comments = @article.comments.paginate(page: params[:page], per_page: 5)
    @is_bookmarked = @article.is_bookmarked(current_user)
  end

  def edit
  end

  def update
    @article.image.attachments.purge
    if @article.update(article_params)
      flash[:success] = "Article was updated successfully!"
      redirect_to @article
    else
      render "edit"
    end
  end

  def destroy
    @article.destroy
    flash[:success] = "Article deleted successfully!"
    redirect_to articles_path
  end

  def like
    #@like = Like.find(params[:id])
    like = @article.likes.where(user_id: current_user.id).first
    if like.present?
      like.update!(like: params[:like])
    else
      like = Like.create(like: params[:like], user: current_user, article: @article)
    end
    #redirect_to request.referrer
  end

  def delete_image_attachment
    @article = Article.find(params[:id])
    @article.image.attachments.purge
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:name, :description, image: [], category_ids: [])
  end

  def require_same_user
    if current_user != @article.user and !current_user.admin?
      flash[:danger] = "You can only edit or delete your own articles"
      redirect_to articles_path
    end
  end

  def require_user_like
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to :back
    end
  end
end
