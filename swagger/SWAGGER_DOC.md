Add the following gems
group :development, :test do
  gem 'rswag-api'
  gem 'rswag-ui'
  gem 'rswag-specs'
end

docker-compose run web bundle install

docker-compose run web bundle update rswag rspec-rails
docker-compose run web bundle list | grep rswag
docker-compose run web rspec spec/integration/cars_spec.rb
docker-compose down
docker-compose build web

docker-compose up
docker-compose run web rspec spec/integration/cars_spec.rb

docker-compose run web rails rswag:specs:swaggerize