module Api
  module V1
    class CommentsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_article, only: [:index, :create]
      before_action :set_comment, only: [:destroy]

      def index
        render json: @article.comments.order(id: :asc)
      end

      def create
        @comment = @article.comments.new(comment_params)

        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @comment.destroy
        head :no_content
      end

      private

      def set_article
        @article = Article.find(params[:article_id])
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:author, :body)
      end
    end
  end
end
