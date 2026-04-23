module ApplicationHelper
  def rating_form_for(rateable: nil, page_name: nil)
    rating = Rating.new
    rating.rateable = rateable if rateable
    rating.page_name = page_name if page_name
    render partial: 'shared/rating_form', locals: { rating: rating }
  end
end
