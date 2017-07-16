require "rails_helper"

RSpec.describe Account, :type => :model do
  describe ".check_pocket_period" do
    before(:each) do
      account = Account.new(last_balance: 0,
                 pocket_money: 0,
                 pocket_time: 30,
                 user_id: 1,
                 )
    end

    it "generate pocket period if nil" do
      account.check_pocket_period
    
      expect(account.pocket_period).to_not be_nil
      expect(account.balance_update_time).to_not be_nil
    end
  end

  # describe ".find_expenses" do
  #   user = User.create(email: Faker::Internet.free_email, password: "password")
  #   expense1 = Expense.create(amount: -100, user_id: user.id, date: "2017-07-02")
  #   expense2 = Expense.create(amount: -250, user_id: user.id, date: "2017-07-10")
  #   expense3 = Expense.create(amount: -500, user_id: user.id, date: "2017-07-20")
  #   account = Account.create(last_balance: 100, user_id: user.id)
    
  #   it "should return all expenses with that user Id" do
  #     expenses = Expense.all
  #     result = account.find_expenses(user.id, "2017-07-01", "2017-07-02")
  #     expect(result.length).to eq(Expense.all.count)
  #   end

  #   it "all amounts from the expenses should return 850" do
  #     result = account.find_expenses(user.id, "2017-07-01", "2017-07-02")
  #     total = 0
  #     expect(result).to eq("foo")
  #     result.each do |expense|
  #       total += expense.amount
  #     end
  #     expect(total).to eq(-850)
  #   end
  # end

  # describe ".find_events" do
  #   user = User.create(email: Faker::Internet.free_email, password: "password")
  #   event1 = Event.create(amount: -100, user_id: user.id)
  #     date1 = EventDate.ceate(date: "2017-07-02", event_id: event1.id)
  #     date2 = EventDate.ceate(date: "2017-07-08", event_id: event1.id)
  #   event2 = Event.create(amount: -250, user_id: user.id)
  #     date3 = EventDate.ceate(date: "2017-07-02", event_id: event2.id)
  #     date4 = EventDate.ceate(date: "2017-07-08", event_id: event2.id)
  #   account = Account.create(last_balance: 100, user_id: user.id)

  #   it "should bring in all events for a certain date range" do
  #     expect(result.length).to eq(EventDate.all.count)
  #   end

  #   it "should bring in the full amount of those dates" do
  #     expect(total).to eq(-700)
  #   end

  #   it "should be able to find weekly events too in date format" do
  #     event3 = Event.create(amount: 50, user_id: user.id)
  #       week1 = EventWeek.create(week_number: 28, monday: true, friday: true, event_id: event3.id)
  #       week2 = EventWeek.create(week_number: 29, sunday: true, saturday: true, event_id: event3.id)

  #     expect(result.length).to eq(EventDate.all.count + 4)
  #   end

  #   it "should be able to find weekly events too in date format, with specific dates" do
  #     event3 = Event.create(amount: 50, user_id: user.id)
  #       week1 = EventWeek.create(week_number: 28, monday: true, friday: true, event_id: event3.id)
  #       #Monday, Jul 10, 28, Friday, Jul 14, 28
  #       week2 = EventWeek.create(week_number: 29, sunday: true, saturday: true, event_id: event3.id)
  #       #Sunday, Jul 16, 29, Saturday, Jul 22, 29
  #       #BUG: gem's week starts mon, strf time week starts sunday
        
  #     expect(result.length).to eq(EventDate.all.count + 4)
  #   end

  #   it "should not factor in dates outside the range" do
  #     event4 = Event.create(amount: -50, user_id: user.id)
  #     date5 = EventDate.ceate(date: "2017-07-30", event_id: event1.id)
  #     week3 = EventWeek.ceate(week_number: 25, event_id: event4.id, monday: true)

  #     expect(result.length).to eq(4)
  #   end


  # describe ".pocket_money_update" do
  #   account = Account.new(last_balance: 100, user_id: 1)
  #   event = Event.create(amount: 500, weekly: false, user_id: 1)
  #   expense = Expense.create(amount: -100, user_id: 1)

  #   it "should add the last_balance to the event amounts and expenses within a date range" do
  #     total = event.amount + account.last_balance + expense.amount

  #     result = account.pocket_money_update
  #     expect(result).to eq(total)
  #   end


  #   # it "when given a high last_balance and small expenses, should return last_balance minus expenses" do
  #   # end

      # it "ensures you don't run out of money in the middle of the month" do
      # end
  # end

end