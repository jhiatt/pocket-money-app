# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



3.times do
  User.create(email: Faker::Internet.email, password: "password")
end

5.times do
  Tag.create(description: Faker::HarryPotter.location, user_id: User.all.sample)
end

20.times do
  array = ['in', 'out']
  categories = ["Housing", "Utilities", "Savings", "Healthcare", "Debt", "Subscriptions", "Other"]
  Event.create(date: "2017-07-#{rand(30)}", frequency: 1, impact: array.sample, amount: rand(1000), category: categories.sample, tag_id: Tag.all.sample)
end

15.times do
  Expenses.create(date: "2017-07-#{rand(30)}", amount: rand(100), tag_id: Tag.all.sample)
end