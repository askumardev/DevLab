1️⃣ Car GraphQL Type

📄 app/graphql/types/car_type.rb

module Types
  class CarType < Types::BaseObject
    field :id, ID, null: false
    field :brand, String, null: false
    field :model, String, null: false
    field :price, Integer, null: false
    field :year, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

2️⃣ Queries (Fetch Cars)

📄 app/graphql/types/query_type.rb

module Types
  class QueryType < Types::BaseObject
    # GET all cars
    field :cars, [Types::CarType], null: false

    # GET single car
    field :car, Types::CarType, null: true do
      argument :id, ID, required: true
    end

    def cars
      Car.order(created_at: :desc)
    end

    def car(id:)
      Car.find_by(id: id)
    end
  end
end

3️⃣ Create Car Mutation

📄 app/graphql/mutations/create_car.rb

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

4️⃣ Update Car Mutation

📄 app/graphql/mutations/update_car.rb

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

5️⃣ Delete Car Mutation

📄 app/graphql/mutations/delete_car.rb

module Mutations
  class DeleteCar < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      car = Car.find_by(id: id)
      return { success: false, errors: ["Car not found"] } unless car

      car.destroy
      { success: true, errors: [] }
    end
  end
end

6️⃣ Register Mutations

📄 app/graphql/types/mutation_type.rb

module Types
  class MutationType < Types::BaseObject
    field :create_car, mutation: Mutations::CreateCar
    field :update_car, mutation: Mutations::UpdateCar
    field :delete_car, mutation: Mutations::DeleteCar
  end
end

7️⃣ Sample GraphQL Queries
Goto http://localhost:3000/graphiql
🔹 Get all cars
query {
  cars {
    id
    brand
    model
    price
    year
  }
}

🔹 Get one car
query {
  car(id: 1) {
    brand
    model
    price
    year
  }
}

8️⃣ Sample Mutations
🔹 Create car
mutation {
  createCar(
    brand: "Maruti"
    model: "Suzuki"
    price: 100000
    year: 2022
  ) {
    car {
      id
      brand
    }
    errors
  }
}

🔹 Update car
mutation {
  updateCar(
    id: 1
    price: 120000
  ) {
    car {
      id
      price
    }
    errors
  }
}

🔹 Delete car
mutation {
  deleteCar(id: 1) {
    success
    errors
  }
}