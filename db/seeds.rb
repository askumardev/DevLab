# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Seeding Articles..."
Article.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('articles')
Article.create!([
  {
    title: "Getting Started with Rails",
    body: "Rails is a web application framework written in Ruby. It follows the MVC pattern and emphasizes convention over configuration."
  },
  {
    title: "Understanding MVC Architecture",
    body: "The MVC pattern separates an application into three components: Model, View, and Controller. This helps organize code and improve maintainability."
  },
  {
    title: "Active Record Basics",
    body: "Active Record is the ORM used in Rails. It allows you to interact with the database using Ruby objects instead of SQL queries."
  },
  {
    title: "Introduction to Hotwire",
    body: "Hotwire allows you to build modern interactive applications without writing much JavaScript by using Turbo and Stimulus."
  },
  {
    title: "Using PostgreSQL in Rails",
    body: "PostgreSQL is a powerful, open-source relational database system and works seamlessly with Rails."
  }
])
puts "Seeding Articles... Done."
