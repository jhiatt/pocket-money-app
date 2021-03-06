class EventsController < ApplicationController
  before_action :authenticate_user!
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
    if params[:amount] == "" || (params[:start_date] ? (params[:start_date] == "") : (params[:date1] == ""))
      flash[:success] = "Please enter a begining date and amount"
      redirect_to "/events/new"
    else
      if params[:impact] == "in" 
        # && params[:amount].to_i < 0
        amount = -params[:amount]
      elsif params[:impact] == "out"
        # && params[:amount].to_i < 0
        amount = params[:amount].to_f * -1
      end
        @event = Event.new(impact: params[:impact], repeat: params[:repeat], amount: amount, category: params[:category], description: params[:description], user_id: current_user.id, weekly: params[:weekly])
        @event.save 
      if @event.repeat && params[:weekly] == "false"
        occ_time = occurances(params[:date1])
        if params[:date2] != ""
          i = 0
          occ_time.times do
             
            EventDate.create(event_id: @event.id, date: (Date.parse(params[:date2]) + i.month))
            i += 1      
          end
        end
        if params[:date3] != ""
          i = 0
          occ_time.times do
            EventDate.create(event_id: @event.id, date: (Date.parse(params[:date3]) + i.month))
            i += 1 
          end     
        end
        if params[:date4] != ""
        i = 0
          occ_time.times do
            EventDate.create(event_id: @event.id, date: (Date.parse(params[:date4]) + i.month))
            i += 1      
          end
        end
        if params[:date5] != ""
        i = 0
          occ_time.times do
            EventDate.create(event_id: @event.id, date: (Date.parse(params[:date5]) + i.month))
            i += 1    
          end  
        end
      elsif @event.repeat && params[:weekly] == "true"
        #week number to start
        week_num = params[:start_date].to_datetime.strftime("%U").to_i
        year_num = params[:start_date].to_datetime.strftime("%Y").to_i
        
        #the first event may start on a partial week so we will add that before the loop
        first_week = EventWeekly.new(event_id: @event.id,
                             week_number: week_num, 
                             year: year_num,
                             sunday: params[:sunday], 
                             monday: params[:monday],
                             tuesday: params[:tuesday],
                             wednesday: params[:wednesday],
                             thursday: params[:thursday],
                             friday: params[:friday],
                             saturday: params[:saturday])
        first_week.partial_week_update(params[:start_date])
        first_week.save
        weekly_occurances = current_user.account.pocket_time * 2 / 7
        #we loop through the full two periods even though the first week is done in order to round up
        weekly_occurances.times do |i|
          if (week_num + 1 + i) == 53
            week_num = 0 - i
            year_num += 1
          end
          EventWeekly.create(event_id: @event.id,
                             week_number: week_num + 1 + i, 
                             year: year_num,
                             sunday: params[:sunday], 
                             monday: params[:monday],
                             tuesday: params[:tuesday],
                             wednesday: params[:wednesday],
                             thursday: params[:thursday],
                             friday: params[:friday],
                             saturday: params[:saturday])

        end
      end
      current_user.account.pocket_money_update
      redirect_to "/events/"
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    @impact = @event.impact_cleaner
    @date = params[:date]
    # if @event.weekly
    #   WeekToDate::GetDate.get_date(year, week_number, day_as_string)
    # else
    # end
  end

  def edit
    @tags = Tag.where(user_id: current_user.id)
    @categories = ["Housing", "Utilities", "Savings", "Healthcare", "Debt", "Subscriptions", "Other"]
    @event = Event.find_by(id: params[:id])
  end

  def update
    event = Event.find_by(id: params[:id])
    if event.amount != params[:amount]
      week_num_array = WeekToDate::GetWeek.week(params[:date1].to_s)
      week_num = week_num_array[1]
      year_num = week_num_array[0]
      event.update(repeat: false)
      new_event = Event.create(impact: params[:impact], tag_id: params[:tag_id], repeat: params[:repeat], category: params[:category], description: params[:description], amount: params[:amount], user_id: current_user.id)
      EventDate.where("event_id = ? AND date > ?", event.id, params[:date]).update_all(event_id: new_event.id)
      EventWeekly.where("event_id = ? AND week_number > ? AND year > ?", event.id, week_num, year_num).update_all(event_id: new_event.id)
    else
      event.update(impact: params[:impact], tag_id: params[:tag_id], repeat: params[:repeat], category: params[:category], description: params[:description])
    end
    current_user.account.pocket_money_update
    flash[:success] = "Event updated successfully"
    redirect_to "/events"
  end

  def destroy
    event = Event.find_by(id: params[:id])
    event[:repeat] = false
    if params[:date1] == ""
      flash[:success] = "Please enter a begining date"
      redirect_to "/events/#{event.id}/edit"
    else
      if params[:date2] != ""
        monthly_events = EventDate.where("event_id = ? AND date > ? AND date < ?", params[:id], params[:date1].to_datetime, params[:date2].to_datetime)

        week_num1 = params[:date1].to_datetime.strftime("%U").to_i
        week_num2 = params[:date1].to_datetime.strftime("%U").to_i
        year_num1 = params[:date1].to_datetime.strftime("%Y").to_i
        year_num2 = params[:date1].to_datetime.strftime("%Y").to_i      
        first_week = EventWeekly.find_by(event_id: params[:id], week_number: week_num1, year: year_num1)
        last_week = EventWeekly.find_by(event_id: params[:id], week_number: week_num2, year: year_num2)
        #will break over the new year
        weekly_events = EventWeekly.where("event_id = ? AND week_number > ? AND week_number < ?", params[:id], (week_num1 + 1), (week_num2 - 1))

        if first_week
          first_week.beg_week_delete(params[:date1])
        end
        if last_week
          last_week.partial_week_update(params[:date2])
        end

        monthly_events.destroy_all
        weekly_events.destroy_all
      else
        monthly_events = EventDate.where("event_id = ? AND date > ?", params[:id], params[:date1].to_datetime)

        week_num = params[:date1].to_datetime.strftime("%U").to_i
          first_week = EventWeekly.find_by(event_id: params[:id], week_number: week_num)
        #will break over the new year
        weekly_events = EventWeekly.where("event_id = ? AND week_number >= ?", params[:id], week_num + 1)
        if first_week
          first_week.beg_week_delete(params[:date1])
        end
        monthly_events.destroy_all
        weekly_events.destroy_all
      end
      current_user.account.pocket_money_update
      redirect_to "/events"
    end
  end

  def update_pocket
    current_user.account.pocket_money_update
  end

  #delete me
  def hidden
    current_user.account.pocket_money_update
    redirect_to "/events"
  end

  private

  def occurances(date)
    occurances = current_user.account.pocket_time * 2 / 30
    i = 0
    occurances.times do
      EventDate.create(event_id: @event.id, date: (Date.parse(date) + i.month))
      i += 1      
    end
    i
  end


end
