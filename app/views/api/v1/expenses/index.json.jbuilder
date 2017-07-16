json.array! @expenses.each do |expense|
  json.id expense.id
  json.date expense.date
  json.amount expense.amount
  json.tag expense.tag
  json.user_id expense.user_id
end