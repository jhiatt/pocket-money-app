class Account < ApplicationRecord
  belongs_to :user
  #pocket time: number of days factored into pocket money calc
  #pocket period: date one pocket time away from date of last update.  When pocket period is less than 1 pocket time away from today an update should be run. (see def check_pocket_period, and def roll_events)


  def pocket_money_update
####### current user?  is this only for that user's events?
    u_pocket_money = last_balance

    pocket_money_expenses = Expense.where("date > ? AND date < ?", Time.now, (Time.now + pocket_time.days))
    pocket_money_expenses.each do |expense|
      u_pocket_money += expense.amount
    end
    pocket_money_event = Event.where("date > ? AND date < ?", Time.now, (Time.now + pocket_time.days))
    pocket_money_event.each do |event|
      u_pocket_money += event.amount
    end
    update(pocket_money: u_pocket_money)
  end

  def check_pocket_period
    #we want to always keep enough dates ahead fo us for the pocket money calculation.  Pocket_period is the date of our latest 
    if pocket_time.days.from_now > pocket_period
      roll_events
    end
  end

  def roll_events
    #when events are first established we will establish two pocket_time periods of the event
    #events will roll after one pocket_time is passed so there should be a second pocket time already out there.
    #for repeat we will have to set it up by date/day of the week.  If they want to change the date what happens?
      #will this cause issues if they arbitrarily change the pocket time amount?  What if the minimum is 30 days.
      #how can we add the future month of events without messing up the first one (should be solved with the EventDate model)
      #how do we know a pocket_time period has passed, should we add an attribute to account? (purpose of pocket_period)
    #check that all Event_months are present for the next period
      #what criteria do we need to know to find out if an event is already there for that month?
        #A unique event id that matches all the dates
    Event.where.not(frequency: "none").each do |event|
      #need a date range.  Do I need a pocket time table??
      EventDate.where(event_id: event.id).each do |eventdate|
        #checks if the event is there already, if not it adds an instance
        if EventDate.where(event_id: event.id).where.not(date: (eventdate.date + 1.month))
          #all the info will be the same as prev except date
          EventDate.new(event_id: event.id, date: (eventdate.date + 1.month))
        end
      end
      EventWeekly.where.(event_id: event.id).where.not(date: (pocket_time / 7))
    end


    #check that all the Event_weeks are present for the next period
    #add periods after that

  end

# Not sure why this is here
# def set_pocket_time
#   self.pocket_time = 0
# end

end
