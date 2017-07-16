json.array! @expenses.each do |expense|
  json.id expense.id
  json.date expense.date
  json.amount expense.amount
  json.user_id expense.user_id
  if expense.tag
    json.tag_id expense.tag.id
    json.tag_description expense.tag.description
  end
end