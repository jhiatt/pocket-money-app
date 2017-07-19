json.array! @events_all do |eventdate|
  # binding.pry
  # if eventdate.class == "Hash"
    json.date eventdate[:date]
  # else
  #   json.date eventdate.date
  # end
  # binding.pry
  event = eventdate[:event] || Event.find_by(id: eventdate[:event_id])
  # if eventdate.event
    # json.amount eventdate.event.id
    # json.description eventdate.event.description
    # json.category eventdate.event.category
    # json.tag_id eventdate.event.tag_id
    # json.user_id eventdate.event.user_id
    # json.repeat eventdate.event.repeat
    # json.weekly eventdate.event.weekly
  # else
    # event = Event.find_by(id: eventdate[:event_id])
    json.amount event.id
    json.description event.description
    json.category event.category
    json.tag_id event.tag_id
    json.user_id event.user_id
    json.repeat event.repeat
    json.weekly event.weekly
  # end
end