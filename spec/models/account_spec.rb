require "rails_helper"

RSpec.describe Account, :type => :model do
  describe ".check_pocket_period" do
    before(:each) do
      @account = Account.new(last_balance: 0,
                 pocket_money: 0,
                 pocket_time: 30,
                 user_id: 1,
                 )
    end

    it "generate pocket period if nil" do
      @account.check_pocket_period
    
      expect(@account.pocket_period).to_not be_nil
      expect(@account.balance_update_time).to_not be_nil
    end
  end

  describe ".find_expenses" do
    before(:each) do
      @user = User.create(email: Faker::Internet.free_email, password: "password")
      @expense1 = Expense.create(amount: -100, user_id: @user.id, date: "2017-07-02")
      @expense2 = Expense.create(amount: -250, user_id: @user.id, date: "2017-07-10")
      @expense3 = Expense.create(amount: -500, user_id: @user.id, date: "2017-07-20")
      @account = Account.create(last_balance: 100, user_id: @user.id)
    end
    
    it "should return all expenses with that user Id" do
      expenses = Expense.all
      result = @account.find_expenses("2017-07-01", "2017-07-30")
      # binding.pry
      expect(result.length).to eq(Expense.all.count)
    end

    it "all amounts from the expenses should return 850" do
      result = @account.find_expenses("2017-07-01", "2017-07-30")
      total = 0
      # expect(result).to eq("foo")
      result.each do |expense|
        total += expense.amount
      end
      expect(total).to eq(-850)
    end
  end

  describe ".find_events" do
    before(:each) do
      @user = User.create(email: Faker::Internet.free_email, password: "password")
      @event1 = Event.create(amount: -100, user_id: @user.id)
        @date1 = EventDate.create(date: "2017-07-02", event_id: @event1.id)
        @date2 = EventDate.create(date: "2017-07-08", event_id: @event1.id)
      @event2 = Event.create(amount: -250, user_id: @user.id)
        @date3 = EventDate.create(date: "2017-07-02", event_id: @event2.id)
        @date4 = EventDate.create(date: "2017-07-08", event_id: @event2.id)
      @account = Account.create(last_balance: 100, user_id: @user.id)
    end

    it "should bring in all events for a certain date range" do
      result = @account.find_events("2017-07-01", "2017-07-30")
      expect(result.length).to eq(4)
    end

    it "should bring in the full amount of those dates" do
      result = @account.find_events("2017-07-01", "2017-07-30")
      total = 0
      result.each do |event_date|
        total += event_date.event.amount
      end
      expect(total).to eq(-700)
    end

    # it "should be able to find weekly events too in date format" do
    #   event3 = Event.create(amount: 50, user_id: @user.id, weekly: true)
    #     event3.event_weeklies.create(week_number: 28, monday: true, friday: true)
    #     event3.event_weeklies.create(week_number: 29, sunday: true, saturday: true)
    #     binding.pry
    #   result = @account.find_events(@user.id, "2017-07-01", "2017-07-31")
    #   expect(result.length).to eq(EventDate.all.count) # maybe needs a +4??
    # end

    # it "should be able to find weekly events too in date format, with specific dates" do
    #   event3 = Event.create(amount: 50, user_id: @user.id, weekly: true)
    #     week1 = EventWeekly.create(week_number: 28, monday: true, friday: true, event_id: event3.id)
    #     #Monday, Jul 10, 28, Friday, Jul 14, 28
    #     week2 = EventWeekly.create(week_number: 29, sunday: true, saturday: true, event_id: event3.id)
    #     #Sunday, Jul 16, 29, Saturday, Jul 22, 29

    #   #UPDATE THIS          
    #   expect(result.length).to eq(EventDate.all.count + 4)
    # end

    it "should not factor in dates outside the range" do
      @event4 = Event.create(amount: -50, user_id: @user.id)
      @date5 = EventDate.create(date: "2017-07-30", event_id: @event1.id)
      @date6 = EventDate.create(date: "2017-08-01", event_id: @event1.id)      
      @week3 = EventWeekly.create(week_number: 25, event_id: @event4.id, monday: true)

      result = @account.find_events("2017-07-01", "2017-07-31")
      expect(result.length).to eq(5)
    end
  end


  describe ".pocket_money_update" do
    before(:each) do
      @user = User.create(email: Faker::Internet.free_email, password: "password")
      @expense1 = Expense.create(amount: -100, user_id: @user.id, date: "2017-07-02")
      @expense2 = Expense.create(amount: -250, user_id: @user.id, date: "2017-07-10")
      @expense3 = Expense.create(amount: -500, user_id: @user.id, date: "2017-07-20")
      @event1 = Event.create(amount: -100, user_id: @user.id)
        @date1 = EventDate.create(date: "2017-07-02", event_id: @event1.id)
        @date2 = EventDate.create(date: "2017-07-08", event_id: @event1.id)
      @event2 = Event.create(amount: -250, user_id: @user.id)
        @date3 = EventDate.create(date: "2017-07-02", event_id: @event2.id)
        @date4 = EventDate.create(date: "2017-07-08", event_id: @event2.id)
      @account = Account.create(last_balance: 10000, user_id: @user.id, balance_update_time: "2017-07-01", pocket_time: "30")
    end

    # it "should return a combinded length of both arrays" do
    #   expect(@account.pocket_money_update.length).to eq(7)
    # end

    it "should add the last_balance to the event amounts and expenses within a date range" do
      #total = event.amount + account.last_balance + expense.amount
      total = 10000 - 100 - 250 - 500 - 100 - 100 - 250 - 250
      result = @account.pocket_money_update
      expect(result).to eq(total)
    end

    it "should update the pocket money attribute for the user" do
      total = 10000 - 100 - 250 - 500 - 100 - 100 - 250 - 250
      @account.pocket_money_update
      expect(@account.pocket_money).to eq(total)
    end

    # it "should not require a hardcoded or imputed date range" do
    # end


    it "when given a high last_balance and small expenses, should return last_balance minus expenses" do
      @event5 = Event.create(amount: -9550, user_id: @user.id)
        @date8 = EventDate.create(date: "2017-07-02", event_id: @event2.id)
      @event5 = Event.create(amount: 3550, user_id: @user.id)
        @date8 = EventDate.create(date: "2017-07-25", event_id: @event2.id)

      @account.pocket_money_update
      expect(@account.pocket_money).to be > 0
    end

    it "ensures you don't run out of money in the middle of the month" do
      @event5 = Event.create(amount: -5950, user_id: @user.id)
        @date8 = EventDate.create(date: "2017-07-02", event_id: @event5.id)
      @event6 = Event.create(amount: 5550, user_id: @user.id)
        @date8 = EventDate.create(date: "2017-07-25", event_id: @event6.id)

      @account.pocket_money_update
      expect(@account.pocket_money).to eq(6550)

    end
  end

end