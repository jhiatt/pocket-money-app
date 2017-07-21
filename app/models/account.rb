class Account < ApplicationRecord
  belongs_to :user
  after_initialize :set_defaults
  #pocket time: number of days factored into pocket money calc
  #pocket period: date one pocket time away from date of last update.  When pocket period is less than 1 pocket time away from today an update should be run. (see def check_pocket_period, and def roll_events)

  def set_defaults
    self.balance_update_time ||= Time.now
  end

  def pocket_money_update
    check_pocket_period
    #used to calculate the reserved amount only
    bucket = 0
    #reserve_amount is the amount I need to start with to make sure no individual day is negative (an overdraft)
    reserve_amount = 0

    # expense_array = self.find_expenses(balance_update_time, (balance_update_time + pocket_time.days))
    # event_array = self.find_events(balance_update_time, (balance_update_time + pocket_time.days))
    expense_array = self.find_expenses(balance_update_time, pocket_period)
    event_array = self.find_events(balance_update_time, pocket_period)

    #obtain an array of all the dates
    array_of_dates = (balance_update_time.to_date..(balance_update_time + pocket_time.days).to_date).map{ |date| date.strftime("%Y-%m-%d") }
    array_of_dates.each do |date|
      #get the value of each day individually
      x = Expense.where(id: expense_array.map{ |expense| expense[:id] }, date: date)
      x.each do |exp|
        # new_pocket_money += exp.amount
        bucket += exp.amount
      end
      y = EventDate.where(id: event_array.map{ |event| event[:id] }, date: date)
      y.each do |object|
          # new_pocket_money += object.event.amount
          bucket += object.event.amount
      end
        ##(if I do incorporate event_weeks I have to add something for that here)

      #if the day brings us negative, add to the reserve amount 
      if bucket < 0
        reserve_amount -= bucket
        #  
        bucket = 0
      end
    end
    recent_amounts = 0
    event_array.each do |event|
      if event.date > balance_update_time && event.date < Time.now
        recent_amounts += event.event.amount
      end
    end
    expense_array.each do |expense|
      if expense.date > balance_update_time && expense.date < Time.now
        recent_amounts += expense.amount
      end
    end



    current_balance = last_balance - recent_amounts
    new_pocket_money = current_balance - reserve_amount

    update(pocket_money: new_pocket_money)
     
    return new_pocket_money
  end

  def check_pocket_period
    #we want to always keep enough dates ahead of us for the pocket money calculation.  If we get within one pocket_time we need to roll another set of events so that we are allways two pocket_times ahead
    # Pocket Period is the date of the next update
    if pocket_period && (Time.now > pocket_period)
        roll_events
        update(pocket_period: (Time.now + pocket_time.days))
    elsif pocket_period.nil?
        roll_events
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

    user.events.where(weekly: false, repeat: true).each do |event|
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

    user.events.where(weekly: true, repeat: true).each do |event|
      EventWeekly.where(event_id: event.id).each do |eventweek|
        #for each week number in the period check if it is there and then add it if it's not
        j = 1
        ((pocket_time * 2 + 30) / 7).times do |new_eventweek|
          week_num = eventweek.week_number
          week_num += j
          year_num = eventweek.year
          if j > 52
            week_num = 1
            year_num = year_num.to_i + 1
          end
          unless EventWeekly.exists?(event_id: event.id, week_number: (eventweek.week_number + j))
            EventWeekly.create(event_id: event.id,
                            year: year_num,
                            week_number: week_num, 
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
        date_1 = WeekToDate::GetWeek.week(date1.to_s)
        date_2 = WeekToDate::GetWeek.week(date2.to_s)
        day_of_week = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
        @weeks_array = event.event_weeklies.where("year >= ? AND year <= ? AND week_number > ? AND week_number < ?", 
                                                  date_1[0], date_2[0], date_1[1], date_2[1])
        @weeks_array.each do |week|
          day_of_week.each do |day|
            if week[day] == true
              # week_hash = {date: WeekToDate::GetDate.get_date(week["year"].to_i, week["week_number"], day), id: week["event_id"]}
              week_hash = EventDate.new(date: WeekToDate::GetDate.get_date(week["year"].to_i, week["week_number"], day), event_id: week["event_id"])
              if week_hash[:date] > date1.to_date && week_hash[:date] < date2.to_date
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
