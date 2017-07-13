require "rails_helper"

RSpec.describe Account, :type => :model do
  describe ".check_pocket_period" do
    account = Account.new(last_balance: 0,
                 pocket_money: 0,
                 pocket_time: 30,
                 user_id: 1,

                 )
    it "generate pocket period if nil" do
      account.check_pocket_period
    
      expect(account.pocket_period).should_not be_nil
      expect(account.balance_update_time).should_not be_nil
    end
  end

  describe ".pocket_money_update" do
    account = Account.new(last_balance: 100, user_id: 1)
    event = Event.create(amount: 500, weekly: false, user_id: 1)
    expense = Expense.create(amount: -100, user_id: 1)

    it "should find all events for that account"

    # it "when given a high last_balance and small expenses, should return last_balance minus expenses" do
    # end
  end

end