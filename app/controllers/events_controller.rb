class EventsController < ApplicationController
  before_action :authenticate_user!
  after_action :update_pocket, only: [:create, :update, :destroy]
  def index
    @event_dates = EventDate.all
  end

  def new
    if current_user && current_user.tags.any?
      @tags = Tag.where(user_id: current_user.id)
    else
      @tags = []
    end
    @categories = ["Housing", "Utilities", "Savings", "Healthcare", "Debt", "Subscriptions", "Other"]
    @event = Event.new
  end

  def create
    @event = Event.new(impact: params[:impact], repeat: params[:repeat], amount: params[:amount], category: params[:category], description: params[:description], user_id: current_user.id)
    @event.save 
    occurances = current_user.account.pocket_time * 2 / 30
    if @event.repeat && params[:frequency] = "monthly"
      i = 0
      occurances.times do
        EventDate.create(event_id: @event.id, date: (params[:date1] + i.month))
        i += 1
      end
      if params[:date2]
        i = 0
        occurances.times do
          EventDate.create(event_id: @event.id, date: (params[:date2] + i.month))
          i += 1      
        end
      end
      if params[:date3]
        i = 0
        occurances.times do
          EventDate.create(event_id: @event.id, date: (params[:date3] + i.month))
          i += 1 
        end     
      end
      if params[:date4]
      i = 0
        occurances.times do
          EventDate.create(event_id: @event.id, date: (params[:date4] + i.month))
          i += 1      
        end
      end
      if params[:date5]
      i = 0
        occurances.times do
          EventDate.create(event_id: @event.id, date: (params[:date5] + i.month))
          i += 1    
        end  
      end
    elsif @event.repeat && params[:frequency] = "weekly"
      #week number to start
      week_num = params[:start_date].to_datetime.strftime("%U").to_i
      #day of the week to start in the first week
      day = date.wday
      

      #the first event may start on a partial week so we will add that before the loop
      first_week = EventWeekly.new(event_id: @event.id,
                           week_number: week_num + i, 
                           sunday: params[:sunday], 
                           monday: params[:monday],
                           tuesday: params[:tuesday],
                           wednesday: params[:wednesday],
                           thursday: params[:thursday],
                           friday: params[:friday],
                           saturday: params[:saturday])
      if day = 1
        first_week[sunday] = false
      elsif day = 2
        first_week[sunday] = false
        first_week[monday] = false
      elsif day = 3
        first_week[sunday] = false
        first_week[monday] = false
        first_week[tuesday] = false
      elsif day = 4
        first_week[sunday] = false
        first_week[monday] = false
        first_week[tuesday] = false
        first_week[wednesday] = false
      elsif day = 5
        first_week[sunday] = false
        first_week[monday] = false
        first_week[tuesday] = false
        first_week[wednesday] = false
        first_week[thursday] = false
      elsif day = 6
        first_week[sunday] = false
        first_week[monday] = false
        first_week[tuesday] = false
        first_week[wednesday] = false
        first_week[thursday] = false
        first_week[friday] = false
      end
      first_week.save
      weekly_occurances = occurnaces / 7
      #we loop through the full two periods even though the first week is done in order to round up
      weekly_occurances.times do |i|
        EventWeekly.create(event_id: @event.id,
                           week_number: week_num + i, 
                           sunday: params[:sunday], 
                           monday: params[:monday],
                           tuesday: params[:tuesday],
                           wednesday: params[:wednesday],
                           thursday: params[:thursday],
                           friday: params[:friday],
                           saturday: params[:saturday])
      end
    end
    redirect_to "/events/#{@event.id}"
  end

  def show
    @event = Event.find_by(id: params[:id])
    @impact = @event.impact_cleaner
  end

  def edit
    @tags = Tag.where(user_id: current_user.id)
    @categories = ["Housing", "Utilities", "Savings", "Healthcare", "Debt", "Subscriptions", "Other"]
    @event = Event.find_by(id: params[:id])
  end

  def update
    event = Event.find_by(id: params[:id])
    event.update(impact: params[:impact], repeat: params[:repeat], amount: params[:amount], category: params[:category], description: params[:description])
  end

  def destroy
    event = Event.find_by(id: params[:id])
    event[:repeat] = false
    if params[:date2]
      monthly_events = EventDate.where("event_id = ? AND date < ? AND date < ?", params[:id], params[:date1], params[:date2])
      weekly_events = EventWeekly.where(event_id: params[:id])
      monthly_events.destroy_all
      weekly_events.destroy_all
    else
      EventDate.where("event_id = ? AND date < ? AND date < ?", params[:id], params[:date1], params[:date2])

    end
  end

end
