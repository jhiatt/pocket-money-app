class EventsController < ApplicationController

  def index
    @events = Event.all
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
    @event = Event.new(date: params[:date], impact: params[:impact], frequency: params[:frequency], amount: params[:amount], category: params[:category])
    @event.save 
    redirect_to "/events/#{@event.id}"
  end

  def show
    @event = Event.find_by(id: params[:id])
    @impact = @event.impact_cleaner
  end

  def edit
    @tags = Tag.where(user_id: current_user.id)
    @categories = ["Housing", "Utilities", "Savings", "Healthcare", "Debt", "Subscriptions", "Other"]
    @event = Event.find_by(params[:id])
  end

  def update
    Event.update(date: params[:date], impact: params[:impact], frequency: params[:frequency], amount: params[:amount], category: params[:category])
  end

  def destroy
    event = Event.find_by(params[:id])
    event.destroy
  end

end
