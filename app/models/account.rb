class Account < ApplicationRecord
  belongs_to :user


  def pocket_money_update
####### current user?  is this only for that user's events?
    u_pocket_money = last_balance

    pocket_money_expenses = Expense.where("date > ? AND date < ?", Time.now, (Time.now + pocket_time.days))
    pocket_money_expenses.each do |expense|
      u_pocket_money += expense.amount
    end
    pocket_money_event = Event.where("date > ? AND date < ?", Time.now, (Time.now + pocket_time.days))
    pocket_money_event.each do |event|
      u_pocket_money += event.amount
    end
    update(pocket_money: u_pocket_money)
  end

# Not sure why this is here
# def set_pocket_time
#   self.pocket_time = 0
# end

end
