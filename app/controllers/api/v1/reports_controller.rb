module Api
  module V1
    class ReportsController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        articles = Article
          .left_joins(:comments)
          .includes(:sections)
          .select("articles.*, COUNT(comments.id) AS comments_count")
          .group("articles.id")
          .order("articles.id ASC")

        render json: articles.as_json(
          only: [:id, :title, :body],
          methods: [:comments_count],
          include: {
            sections: { only: [:id, :heading, :content, :position] }
          }
        )
      end
    end
  end
end
