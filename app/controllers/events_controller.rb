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
    if @event.repeat && params[:frequency] = "monthly"
      occurances(params[:date1])
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
      first_week.partial_week_update(params[:start_date])
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
    if event.amount != params[:amount]
      week_num = params[:date].to_datetime.strftime("%U").to_i
      event.update(repeat: false)
      new_event = Event.create(impact: params[:impact], tag_id: params[:tag_id], repeat: params[:repeat], category: params[:category], description: params[:description], amount: params[:amount])
      EventDate.where("event_id = ? AND date > ?", event.id, params[:date]).update_all(event_id: new_event.id)
      EventDate.weekly("event_id = ? AND week_number > ?", event.id, week_num).update_all(event_id: new_event.id)
    else
      event.update(impact: params[:impact], tag_id: params[:tag_id], repeat: params[:repeat], category: params[:category], description: params[:description])
    end
  end

  def destroy
    event = Event.find_by(id: params[:id])
    event[:repeat] = false
    if params[:date2]
      monthly_events = EventDate.where("event_id = ? AND date < ? AND date > ?", params[:id], params[:date1], params[:date2])

      week_num1 = params[:date1].to_datetime.strftime("%U").to_i
      week_num2 = params[:date1].to_datetime.strftime("%U").to_i
      first_week = EventWeekly.find_by(event_id: params[:id], week_number: week_num1)
      last_week = EventWeekly.find_by(event_id: params[:id], week_number: week_num2)
      weekly_events = EventWeekly.where("event_id = ? AND week_number < ? AND week_number < ?", params[:id], (week_num1 + 1), (week_num2 - 1))

      first_week.beg_week_delete(params[:date1])
      last_week.partial_week_update(params[:date2])

      monthly_events.destroy_all
      weekly_events.destroy_all
    else
      monthly_events = EventDate.where("event_id = ? AND date < ?", params[:id], params[:date1], params[:date2])

      week_num = params[:date1].to_datetime.strftime("%U").to_i
      first_week = EventWeekly.find_by(event_id: params[:id], week_number: week_num)
      weekly_events = EventWeekly.where("event_id = ? AND week_number < ?", params[:id], week_num + 1)

      first_week.beg_week_delete(params[:date1])
      monthly_events.destroy_all
      weekly_events.destroy_all
    end
  end

  def update_pocket
    current_user.account.pocket_money_update
  end

  private

  def occurances(date)
    occurances = current_user.account.pocket_time * 2 / 30
    i = 0
    occurances.times do
      EventDate.create(event_id: @event.id, date: (date + i.month))
      i += 1      
    end
  end


end
