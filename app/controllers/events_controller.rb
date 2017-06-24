class EventsController < ApplicationController
  before_action :authenticate_user!
  after_action :update_pocket only: [:creat, :update, :destroy]
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
    @event = Event.new(date: params[:date], impact: params[:impact], frequency: params[:frequency], amount: params[:amount], category: params[:category], description: params[:description], user_id: current_user.id)
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
    @event = Event.find_by(id: params[:id])
  end

  def update
    Event.update(date: params[:date], impact: params[:impact], frequency: params[:frequency], amount: params[:amount], category: params[:category], description: params[:description])
  end

  def destroy
    event = Event.find_by(params[:id])
    event.destroy
  end

end
