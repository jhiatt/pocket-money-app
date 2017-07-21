require "rails_helper"

RSpec.describe Account, :type => :model do
  describe ".check_pocket_period" do
    before(:each) do
      @user = User.create(email: Faker::Internet.free_email, password: "password")
      @account = Account.create(last_balance: 0,
                 pocket_money: 0,
                 pocket_time: 30,
                 user_id: @user.id,
                 )
      @event1 = Event.create(amount: -100, user_id: @user.id)
        @date1 = EventDate.create(date: "2017-07-02", event_id: @event1.id)

    end

    it "generate pocket period if nil" do
      @account.check_pocket_period
    
      expect(@account.pocket_period).to_not be_nil
      expect(@account.balance_update_time).to_not be_nil
    end

    it "updates pocket_period" do
      @account.update(pocket_period: (Time.now - 1.day))
      @account.check_pocket_period
      expect(@account.pocket_period).to be_between((Time.now + 29.days), (Time.now + 31.days)).inclusive
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
      #  
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

    #####ask kenny
    # before(:each) do
    # end
    it "should be able to find weekly events too in date format" do
      @event3 = Event.create(amount: 50, user_id: @user.id, weekly: true)
        @event_week1 = EventWeekly.create(event_id: @event3.id, week_number: 28, monday: true, friday: true, year: 2017)
        @event3.event_weeklies.create(week_number: 29, sunday: true, saturday: true, year: 2017)
        result = @account.find_events("2017-07-01", "2017-07-31")
        expect(result.length).to eq(EventDate.all.count + 4)
        @event_week1.destroy
        EventWeekly.last.destroy
    end

    #returning dates correctly
    # it "should be able to find weekly events too in date format, with specific dates" do
    #   @event3 = Event.create(amount: 50, user_id: @user.id, weekly: true)
    #     week1 = EventWeekly.create(week_number: 28, monday: true, friday: true, event_id: @event3.id)
    #     #Monday, Jul 10, 28, Friday, Jul 14, 28
    #     week2 = EventWeekly.create(week_number: 29, sunday: true, saturday: true, event_id: @event3.id)
    #     #Sunday, Jul 16, 29, Saturday, Jul 22, 29
    #     array = []

    #   result = @account.find_events("2017-07-01", "2017-07-31")          
    #   expect(result).to eq(array)
    #   @event_week1.destroy
    #     EventWeekly.last.destroy
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
      @account = Account.create(last_balance: 10000, pocket_money: 120, user_id: @user.id, balance_update_time: "2017-07-01", pocket_time: "30")
    end

    # it "should return a combinded length of both arrays" do
    #   expect(@account.pocket_money_update.length).to eq(7)
    # end

    it "should add the last_balance to the event amounts and expenses within a date range" do
      @event4 = Event.create(amount: -50, user_id: @user.id, weekly: true)
      @week3 = EventWeekly.create(week_number: 27, event_id: @event4.id, monday: true, year: 2017)
      
      #total = event.amount + account.last_balance + expense.amount
      total = 10000 - 100 - 250 - 500 - 100 - 100 - 250 - 250 - 50 + 50
      result = @account.pocket_money_update
      expect(result).to eq(total)
      expect(@account.pocket_money).to eq(total)
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
      @expense5 = Expense.create(amount: 300, user_id: @user.id, date: "2017-07-09")
      @expense6 = Expense.create(amount: 400, user_id: @user.id, date: "2017-07-15")

      @account.pocket_money_update
      expect(@account.pocket_money).to eq(3200)
    end
  end

  describe ".roll_events" do
    before(:each) do
      @user = User.create(email: Faker::Internet.free_email, password: "password")
      @account = Account.create(last_balance: 10000, user_id: @user.id, balance_update_time: "2017-07-01", pocket_time: 30)
      @event1 = Event.create(amount: -100, user_id: @user.id, repeat: true, weekly: false)
        @date1 = EventDate.create(date: "2017-07-02", event_id: @event1.id)
        @date2 = EventDate.create(date: "2017-07-08", event_id: @event1.id)
      @event2 = Event.create(amount: -250, user_id: @user.id, repeat: true, weekly: false)
        @date3 = EventDate.create(date: "2017-07-02", event_id: @event2.id)
        @date4 = EventDate.create(date: "2017-07-08", event_id: @event2.id)
    end

    it "should create events for 2 month after current events for EventDates" do
      @account.roll_events
      expect(EventDate.all.length).to eq(16)
    end

    # appears to be working , difficult to anticipate array
    # it "should create events with the exact same day of the month as previous" do
    #   @account.roll_events
    #   events = @event2.event_dates.all
    #   array = []
    #   events.each do |event|
    #     array << event.date.to_date
    #   end
    #   array2 = ["Sun, 02 Jul 2017", "Sat, 08 Jul 2017", "Wed, 02 Aug 2017", "Sat, 02 Sep 2017", "Mon, 02 Oct 2017", "Tue, 08 Aug 2017", "Fri, 08 Sep 2017", "Sun, 08 Oct 2017"]
    #   expect(array).to eq(array2)
    # end

    # appears to be working , difficult to anticipate array
    # it "should create weekly events with the exact same day of the week as previous" do
    #   # before(:each) do
    #     @event3 = Event.create(amount: 50, user_id: @user.id, weekly: true, repeat: true)
    #       @event_week1 = EventWeekly.create(event_id: @event3.id, week_number: 28, monday: true, friday: true, year: 2017)
    #       # @event3.event_weeklies.create(week_number: 29, sunday: true, saturday: true, year: 2017)
    #   # end

    #   @account.roll_events
    #   events = @event3.event_weeklies.all
    #   array = []
    #   events.each do |event|
    #     array << event.week_number
    #   end
    #   array2 = [42]
    #   expect(array).to eq(array2)
    # end

  end

end
