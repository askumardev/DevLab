module Mutations
  class UpdateCar < BaseMutation
    argument :id, ID, required: true
    argument :brand, String, required: false
    argument :model, String, required: false
    argument :price, Integer, required: false
    argument :year, Integer, required: false

    field :car, Types::CarType, null: true
    field :errors, [String], null: false

    def resolve(id:, **attrs)
      car = Car.find_by(id: id)
      return { car: nil, errors: ["Car not found"] } unless car

      if car.update(attrs.compact)
        { car: car, errors: [] }
      else
        { car: nil, errors: car.errors.full_messages }
      end
    end
  end
end
