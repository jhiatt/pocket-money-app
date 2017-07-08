
json.id @account.id
json.last_balance @account.last_balance
json.pocket_money @account.pocket_money
json.pocket_time @account.pocket_time
json.user_id @account.user_id
json.pocket_period @account.pocket_period
json.user do 
  json.user_id @account.user.id
  json.email @account.user.email
end