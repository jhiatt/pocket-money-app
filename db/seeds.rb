# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# 3.times do
#   User.create!(email: Faker::Internet.email, password: "password")
# end

# 5.times do
#   Tag.create!(description: Faker::HarryPotter.location, user_id: User.all.sample.id)
# end

# 20.times do
#   array = ['in', 'out']
#   categories = ["Housing", "Utilities", "Savings", "Healthcare", "Debt", "Subscriptions", "Other"]
#   Event.create!(date: "2017-07-#{rand(30)}", frequency: 1, impact: array.sample, amount: rand(1000).to_i, category: categories.sample, tag_id: Tag.all.sample.id, user_id: User.all.sample.id)
# end

# 15.times do
#   Expense.create!(date: Faker::Date.between("2017-07-01", "2017-07-31"), amount: rand(100).to_i, tag_id: Tag.all.sample.id, user_id: User.all.sample.id)
# end

# Expense.all.each do |expense|
#   expense.update(amount: -expense.amount)
# end

# Event.all.each do |event|
#   if event.impact == "out"
#     event.update(amount: -event.amount)
#   end
# end

# User.all.each do |user|
#   user.create_account
# end

# Event.all.each do |event|
#   ed = EventDate.new(event_id: event.id, date:event.date)
#   ed.save
# end

# 10.times do
#   type = [true, false]
#   week = [29, 30]
#   array = ['in', 'out']
#   categories = ["Housing", "Utilities", "Savings", "Healthcare", "Debt", "Subscriptions", "Other"]
#   event = Event.create!(repeat: true, impact: array.sample, amount: rand(1000).to_i, category: categories.sample, tag_id: Tag.all.sample.id, user_id: User.first.id)
#   if type.sample
#     EventDate.create!(date: "2017-07-#{rand(30)}", event_id: event.id)
#   else
#     EventWeekly.create!(week_number: week.sample, sunday: type.sample, monday: type.sample, tuesday: type.sample, wednesday: type.sample, thursday: type.sample, friday: type.sample, saturday: type.sample, event_id: event.id)
#   end
# end

# 25.times do
#   Expense.create!(date: Faker::Date.between("2017-07-01", "2017-07-31"), amount: rand(100).to_i, tag_id: Tag.all.sample.id, user_id: User.first.id)
# end

# Event.where(user_id: 1).each do |event|
#   event.update(description: Faker::HarryPotter.quote)
# end

# Event.all.each do |event|
#   event.update(weekly: false)
# end

# EventWeekly.all.each do |wevent|
#   wevent.event.update(weekly: true)
# end

# EventWeekly.all.each do |event|
#   event.update(year: "2017")
# end
# array = ["in", "out"]
# Event.all.each do |event|
#   event.impact = array.sample
#   if event.impact == "in"
#     event.amount = event.amount.to_d.abs
#   elsif event.impact == "out"
#     event.amount = event.amount.to_d.abs * -1
#   end
#   # puts amount
#   event.save
# end
