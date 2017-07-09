json.array! @tags.each do |tag|
  json.id tag.id
  json.description tag.description
  json.user_id tag.user_id
end