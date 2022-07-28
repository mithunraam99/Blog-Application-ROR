class PagesController < ApplicationController
  
    def home
      article_ids = Article.all.pluck(:id)
      @articles = Article.where(id: article_ids.sample(4))
    end
    
  end