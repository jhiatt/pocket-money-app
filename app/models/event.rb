class Event < ApplicationRecord
  validates :date, :frequency, :amount, :impact, presence: true
  validates :amount, numericality: {only_decimal: true}

  belongs_to :tag, optional: true
  belongs_to :user


#By Jordan: can we do every month on X date? can we do every two weeks or once every two months?
  # def repeat
  #   if params:[frequency] == "Monthly"
  #     1
  #   end
  # end

  def roll_events
    #this will be at the end of the pocket_time period (default is month).
    #when events are first established we will establish two pocket_time periods of the event
    #when events will roll after one pocket_time is passed so there should be a second pocket time already out there.
    #should we assign a unique identifier to each event creation to be shared with all coppied instances?
        #how would this be impacted if the event was deleted (inactivated? frequency none?)
    #for repeat we will have to set it up by date/day of the week.  If they want to change the date what happens?
      #will this cause issues if they arbitrarily change the pocket time amount?  What if the minimum is 30 days.
      #how can we add the future month of events without messing up the first one
      #how do we know a pocket_time period has passed, should we add an attribute to account?
    all_events = Event.all

  end

  def impact_cleaner
    if impact == "in"
      return "Will Pay"
    elsif impact == "out"
      return "Will Receive"
    end
  end

#work around to match Calendar Gem
    def start_time
        self.date 
    end

end
