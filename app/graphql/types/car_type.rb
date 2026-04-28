# frozen_string_literal: true

module Types
  class CarType < Types::BaseObject
    field :id, ID, null: false
    field :brand, String
    field :model, String
    field :price, Float
    field :year, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :delete_car, mutation: Mutations::DeleteCar
  end
end
