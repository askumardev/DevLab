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
                   price: { type: :number },
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
          price: { type: :number },
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

  path '/api/v1/cars/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show a car' do
      tags 'Cars'
      produces 'application/json'

      response '200', 'car found' do
        let(:id) { Car.create(brand: 'BMW', model: 'X5', price: 60000, year: 2023).id }
        run_test!
      end

      response '404', 'car not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update a car' do
      tags 'Cars'
      consumes 'application/json'

      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          brand: { type: :string },
          model: { type: :string },
          price: { type: :number },
          year: { type: :integer }
        }
      }

      response '200', 'car updated' do
        let(:id) { Car.create(brand: 'Audi', model: 'A6', price: 50000, year: 2021).id }
        let(:car) { { price: 52000 } }
        run_test!
      end
    end

    delete 'Delete a car' do
      tags 'Cars'

      response '204', 'car deleted' do
        let(:id) { Car.create(brand: 'Ford', model: 'Focus', price: 12000, year: 2019).id }
        run_test!
      end
    end
  end
end
