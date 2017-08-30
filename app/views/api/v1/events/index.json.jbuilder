json.array! @events_all do |eventdate|
  
  json.date eventdate[:date]

  event = eventdate[:event] || Event.find_by(id: eventdate[:event_id])
    json.amount event.id
    json.description event.description
    json.category event.category
    json.tag_id event.tag_id
    json.user_id event.user_id
    json.repeat event.repeat
    json.weekly event.weekly

end