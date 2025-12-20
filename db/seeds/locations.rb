require 'csv'

csv_file = Rails.root.join('db', 'data', 'locations.csv')

puts "Seeding Indian locations..."

CSV.foreach(csv_file, headers: true) do |row|
  Location.find_or_create_by!(
    state: row['state'],
    district: row['district'],
    pincode: row['pincode']
  )
end

puts "Seeding locations completed!"
