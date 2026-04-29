module Api
  module V1
    class ArticlesController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_article, only: [:show, :update, :destroy]

      def index
        render json: Article.order(id: :asc)
      end

      def show
        render json: @article
      end

      def create
        @article = Article.new(article_params)
        if @article.save
          render json: @article, status: :created
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      def update
        if @article.update(article_params)
          render json: @article
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @article.destroy
        head :no_content
      end

      private

      def set_article
        @article = Article.find(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :body)
      end
    end
  end
end
