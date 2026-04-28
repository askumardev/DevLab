class PagesController < ApplicationController
  def react_client
    #@cars = Car.select(:id, :brand, :model, :price, :year)
  end

  def cars_index
    @cars = Car.select(:id, :brand, :model, :price, :year)
  end
end
