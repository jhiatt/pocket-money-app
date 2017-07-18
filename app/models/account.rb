class Account < ApplicationRecord
  belongs_to :user
  after_initialize :set_defaults
  #pocket time: number of days factored into pocket money calc
  #pocket period: date one pocket time away from date of last update.  When pocket period is less than 1 pocket time away from today an update should be run. (see def check_pocket_period, and def roll_events)

  def set_defaults
    self.balance_update_time ||= "2000-01-01 01:00:00"
  end

  def pocket_money_update
    #the new PM calculation
    new_pocket_money = 0
    #used to calculate the reserved amount only
    bucket = 0
    #reserve_amount is the amount I need to start with to make sure no individual day is negative (an overdraft)
    reserve_amount = 0

    #needed to update the date range to be as of when last updated
    expense_array = self.find_expenses(balance_update_time, (balance_update_time + pocket_time.days))
    event_array = self.find_events(balance_update_time, (balance_update_time + pocket_time.days))

    array_of_dates = (balance_update_time.to_date..(balance_update_time + pocket_time.days).to_date).map{ |date| date.strftime("%Y-%m-%d") }
    array_of_dates.each do |date|
      x = Expense.where(id: expense_array.map(&:id), date: date)
      x.each do |exp|
        new_pocket_money += exp.amount
        bucket += exp.amount
      end
      y = EventDate.where(id: event_array.map(&:id), date: date)
      y.each do |object|
          new_pocket_money += object.event.amount
          bucket += object.event.amount
      end
      #if I do incorporate event_weeks I have to add something for that here
      if bucket < 0
        reserve_amount -= bucket
        binding.pry
        bucket = 0
      end
    end

    new_pocket_money += last_balance
    new_pocket_money -= reserve_amount
    binding.pry
    update(pocket_money: new_pocket_money)
    return new_pocket_money

    # pocket_money_event = Event.joins(:event_dates).where("event_dates.date > ? AND event_dates.date < ?", balance_update_time, (balance_update_time + pocket_time.days))
    # pocket_money_event.each do |event|
    #   u_pocket_money += event.amount
    # end
    # update(pocket_money: u_pocket_money)



  end

  def check_pocket_period
    #we want to always keep enough dates ahead fo us for the pocket money calculation.  Pocket_period is the date of our latest 
    if pocket_period && (pocket_time.days.from_now > pocket_period)
        # roll_events
        update(pocket_period: (Time.now + pocket_time))
    elsif pocket_period.nil?
        # roll_events
        update(pocket_period: (Time.now + pocket_time.days))
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

  def find_expenses(date1, date2)
    expenses = Expense.where("user_id = ? AND date > ? AND date < ?", self.user.id, date1, date2)
  end

  def find_events(date1, date2)
    user = self.user
    events = user.events
    event_array = []
    events.each do |event|
      if event.weekly
        date_1 = WeekToDate::GetWeek.week(date1)
        date_2 = WeekToDate::GetWeek.week(date2)
        day_of_week = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
        @weeks_array = event.event_weeklies.where("year = ? AND year = ? AND week_number > ? AND week_number < ?", 
                                                  date_1[0], date_2[0], date_1[1], date_2[1])
        @weeks_array.each do |week|
          day_of_week.each do |day|
            if week.day == true
              week_hash = {date: WeekToDate::GetDate.get_date(week["year"], week["week_number"], day), event_id: week["event_id"]}
              if week_hash["date"] > date1 && week_hash["date"] < date2
                event_array << week_hash
              end
            end
          end
        end
        
      else
        event_array << event.event_dates.where("date > ? AND date < ?", date1, date2)
      end
    end
    event_array.flatten
  end



  private


end
