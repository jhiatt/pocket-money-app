class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tags
  has_many :events
  has_many :expenses

  before_create :set_pocket_time

  def pocket_money_update
    u_pocket_money = last_balance

    pocket_money_expenses = Expense.where("user_id = ? AND date > ? AND date < ?", id, Time.now, (Time.now + pocket_time.days))
    pocket_money_expenses.each do |expense|
      u_pocket_money += expense.amount
    end
    pocket_money_event = Event.where("user_id = ? AND date > ? AND date < ?", id, Time.now, (Time.now + pocket_time.days))
    pocket_money_event.each do |event|
      u_pocket_money += event.amount
    end
    User.update(pocket_money: u_pocket_money)
  end

  def set_pocket_time
    self.pocket_time = 0
  end
end
