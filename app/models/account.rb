class Account < ApplicationRecord
  belongs_to :user
  after_initialize :set_defaults
  #pocket time: number of days factored into pocket money calc
  #pocket period: date one pocket time away from date of last update.  When pocket period is less than 1 pocket time away from today an update should be run. (see def check_pocket_period, and def roll_events)

  def set_defaults
    self.balance_update_time ||= "2000-01-01 01:00:00"
  end

  def pocket_money_update
    #need to update the date range to be as of when last updated
    # u_pocket_money = last_balance

    # pocket_money_expenses = Expense.where("date > ? AND date < ?", balance_update_time, (balance_update_time + pocket_time.days))
    # pocket_money_expenses.each do |expense|
    #   u_pocket_money += expense.amount
    # end

    # pocket_money_event = Event.joins(:event_dates).where("event_dates.date > ? AND event_dates.date < ?", balance_update_time, (balance_update_time + pocket_time.days))
    # pocket_money_event.each do |event|
    #   u_pocket_money += event.amount
    # end
    # update(pocket_money: u_pocket_money)

    find_expenses(Time.now)



  end

  def check_pocket_period
    #we want to always keep enough dates ahead fo us for the pocket money calculation.  Pocket_period is the date of our latest 
    if pocket_period && (pocket_time.days.from_now > pocket_period)
        # roll_events
        update.pocket_period = (Time.now + pocket_time)
    elsif pocket_period.nil?
        # roll_events
        update.pocket_period = (Time.now + pocket_time.days)
    end
  end

  def roll_events
    # - when events are first established we will establish two pocket_time periods of the event
    # - events will roll after one pocket_time is passed so there should be a second pocket time already out there.
    # - we will still go through the upcoming pocket_time period checking if events are already there and adding them if they are not
    # - we will then cycle through an extra 30 days beyond the calculation date just in case
    # - Do I need to ckeck to make sure everything was successfull?
    # - the below shoud work as long as pocket time periods are alwasys multiples of 30 and must work for monthly and weekly events
        # We will have to ensure we run this calc everytime the period is passed and/or pocket time has changed
        # Optional: run every time an event is added.
        # How do we handle edited events, should we clear all future events before running this calc.  Will this mess up anything?
          #Maybe we should just destroy all future instances of that event_id when the event is edited

    user.events.where.(weekly: false, repeat: true).each do |event|
    #only repeating events
      EventDate.where(event_id: event.id).each do |eventdate|
      #checks if the event is there already, if not it adds an instance
        i = 1
        ((pocket_time * 2 + 30) / 30).times do
          unless EventDate.exists?(event_id: event.id, date: (eventdate.date + i.month))
            #all the info will be the same as prev except date
            EventDate.create(event_id: event.id, date: (eventdate.date + i.month))
          end
          i += 1
        end
      end
    end

    user.events.where.(weekly: true, repeat: true).each do |event|
      EventWeekly.where(event_id: event.id).each do |eventweek|
        #for each week number in the period check if it is there and then add it if it's not
        j = 1
        ((pocket_time * 2 + 30) / 7).times do |new_eventweek|

          unless EventWeekly.exists?(event_id: event.id, week_number: (new_eventweek.week_number + j))
            EventWeekly.create(event_id: event.id,
                            week_number: (eventweek.week_number + j), 
                            sunday: eventweek.sunday, 
                            monday: eventweek.monday, 
                            tuesday: eventweek.tuesday, 
                            wednesday: eventweek.wednesday, 
                            thursday: eventweek.thursday, 
                            friday: eventweek.friday, 
                            saturday: eventweek.saturday)
          end
          j += 1
        end
      end
    end
  end

  def find_expenses(user_id, date1, date2)
    expenses = Expense.where("user_id = ? AND date > ? AND date < ?", user_id, date1, date2)
  end

  private

# Not sure why this is here
# def set_pocket_time
#   self.pocket_time = 0
# end

end
