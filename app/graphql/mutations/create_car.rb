module Mutations
  class CreateCar < BaseMutation
    argument :brand, String, required: true
    argument :model, String, required: true
    argument :price, Integer, required: true
    argument :year, Integer, required: true

    field :car, Types::CarType, null: true
    field :errors, [String], null: false

    def resolve(brand:, model:, price:, year:)
      car = Car.new(
        brand: brand,
        model: model,
        price: price,
        year: year
      )

      if car.save
        { car: car, errors: [] }
      else
        { car: nil, errors: car.errors.full_messages }
      end
    end
  end
end
