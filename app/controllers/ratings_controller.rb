class RatingsController < ApplicationController
  def index
    @ratings = Rating.recent.limit(100)
  end

  def new
    @rating = build_rating
  end

  def create
    service = RatingService.new(
      params: rating_params,
      rateable: lookup_rateable,
      page_name: rating_params[:page_name]
    )

    @rating = service.create

    if @rating.persisted?
      redirect_back fallback_location: ratings_path, notice: 'Thanks for your rating.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def build_rating
    rating = Rating.new
    if params[:rateable_type].present? && params[:rateable_id].present?
      rating.rateable = params[:rateable_type].safe_constantize&.find_by(id: params[:rateable_id])
    end
    rating.page_name = params[:page_name] if params[:page_name].present?
    rating
  end

  def lookup_rateable
    return unless params[:rating].present? && params[:rating][:rateable_type].present? && params[:rating][:rateable_id].present?

    params[:rating][:rateable_type].safe_constantize&.find_by(id: params[:rating][:rateable_id])
  end

  def rating_params
    params.require(:rating).permit(:name, :email, :score, :comment, :rateable_type, :rateable_id, :page_name)
  end
end
