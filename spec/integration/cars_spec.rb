require 'swagger_helper'

RSpec.describe 'Cars API', type: :request do
  path '/api/v1/cars' do
    get 'List all cars' do
      tags 'Cars'
      produces 'application/json'

      response '200', 'cars found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   brand: { type: :string },
                   model: { type: :string },
                   price: { type: :string }, # Changed from :number to :string
                   year: { type: :integer }
                 },
                 required: %w[id brand model price year]
               }

        run_test!
      end
    end

    post 'Create a car' do
      tags 'Cars'
      consumes 'application/json'

      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          brand: { type: :string },
          model: { type: :string },
          price: { type: :number }, # Input can still be a number
          year: { type: :integer }
        },
        required: %w[brand model price year]
      }

      response '201', 'car created' do
        let(:car) do
          {
            brand: 'Toyota',
            model: 'Corolla',
            price: 15000,
            year: 2022
          }
        end

        run_test!
      end

      response '422', 'invalid request' do
        let(:car) { { brand: '' } }
        run_test!
      end
    end
  end

  # ... rest of your code (GET {id}, PUT, DELETE) stays the same
end
