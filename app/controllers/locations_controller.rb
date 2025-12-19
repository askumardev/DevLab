class LocationsController < ApplicationController
  def index
    @states = Location.distinct.pluck(:state)

    if params[:state].present?
      # Fetch districts and pincodes for the selected state
      locations = Location.where(state: params[:state]).pluck(:district, :pincode)
      render json: locations.map { |district, pincode| "#{district} - #{pincode}" }
    end
  end
end
