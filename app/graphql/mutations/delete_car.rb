module Mutations
  class DeleteCar < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      car = Car.find_by(id: id)

      if car&.destroy
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: ["Car not found"]
        }
      end
    end
  end
end
