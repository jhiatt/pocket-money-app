class Api::V1::EventsController < ApplicationController
    after_action :update_pocket, only: [:create, :update, :destroy]

  def index
    @events = Event.where(user_id: params[:id])
    @event_dates = []
    @event_weeklies = []

    @events.each do |event|
      @event_dates << EventDate.where(event_id: event.id)
      @event_weeklies << EventWeekly.where(event_id: event.id)
    end

    @event_weeklies = @event_weeklies.reject(&:empty?)
    @event_weeklies_date = []
    days_of_week = ["sunday", "monday", "wednesday", "thursday", "friday", "saturday"]
    @event_weeklies.each do |week|
      days_of_week.each do |day|
        if week[0][day] == true
          @event_weeklies_date << {date: WeekToDate::GetDate.get_date(week[0][:year].to_i, week[0][:week_number], day), event_id: week[0][:event_id]}
        end
      end
    end

    # @event_dates_info
    # @event_dates.each do |event|


    # end

    @events_all = (@event_dates + @event_weeklies_date).flatten

    # @events_all.flatten

    render "index.json.jbuilder"
  end

  def update_pocket
    account = Account.find_by(user_id: params[:id])
    account.pocket_money_update
  end


end
