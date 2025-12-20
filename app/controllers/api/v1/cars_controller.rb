module Api
  module V1
    class CarsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_car, only: [:show, :update, :destroy]

      def index
        render json: Car.all
      end

      def show
        render json: @car
      end

      def create
        car = Car.new(car_params)
        if car.save
          render json: car, status: :created
        else
          render json: car.errors, status: :unprocessable_entity
        end
      end

      def update
        if @car.update(car_params)
          render json: @car
        else
          render json: @car.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @car.destroy
        head :no_content
      end

      private

      def set_car
        @car = Car.find(params[:id])
      end

      def car_params
        params.require(:car).permit(:brand, :model, :price, :year)
      end
    end
  end
end
