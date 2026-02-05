Car.destroy_all # optional: clears existing cars

cars = [
  { brand: 'Toyota', model: 'Corolla', price: 15000, year: 2020 },
  { brand: 'Honda', model: 'Civic', price: 18000, year: 2021 },
  { brand: 'Ford', model: 'Mustang', price: 30000, year: 2022 },
  { brand: 'Tesla', model: 'Model 3', price: 40000, year: 2023 },
  { brand: 'BMW', model: 'X5', price: 60000, year: 2022 }
]

cars.each do |car|
  Car.create!(car)
end

puts "Seeded #{Car.count} cars."
