class RatingService
  def initialize(params:, rateable: nil, page_name: nil)
    @params = params
    @rateable = rateable
    @page_name = page_name
  end

  def create
    rating = Rating.new(rating_attributes)
    rating.rateable = @rateable if @rateable.present?
    rating.page_name = @page_name if @page_name.present?
    rating.save
    rating
  end

  private

  def rating_attributes
    @params.slice(:name, :email, :score, :comment)
  end
end
