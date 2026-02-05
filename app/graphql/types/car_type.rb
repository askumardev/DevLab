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
