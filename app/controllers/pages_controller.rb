class PagesController < ApplicationController

  def index
    @expense = Expense.new(date: Time.now)
    if current_user && current_user.tags.any?
      @tags = Tag.where(user_id: current_user.id)
    elsif current_user
      @tags = []
    else
      redirect_to "/users/sign_in"
    end
    # SEARCH BY CURRENT USER FIRST
    # LET USERS DECIDE HOW FAR OUT WE GO FOR DATES
    pocket_money_expenses = Expense.where("user_id => ? AND date > ? AND date < ?", current_user.id, Time.now, (Time.now + 7.weeks))
    @pocket_money = current_user.last_balance
    pocket_money_expenses.each do |expense|
      @pocket_money << expense.amount.to_d
    end
    pocket_money_event = Event.where("user_id => ? AND date > ? AND date < ?", current_user.id, Time.now, (Time.now + 7.weeks))
    pocket_money_event.each do |event|
      @pocket_money << event.amount.to_d
    end
  end

end
