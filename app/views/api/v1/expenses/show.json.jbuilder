json.id @expense.id
json.date @expense.date
json.amount @expense.amount
json.created_at @expense.created_at
json.updated_at @expense.updated_at
if @expense.tag
  json.tag_id @expense.tag.id
  json.tag_description @expense.tag.description
end
json.user_id @expense.user_id
json.account @account
