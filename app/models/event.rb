class Event < ApplicationRecord
  validates :repeat, :amount, :impact, presence: true
  validates :amount, numericality: {only_decimal: true}

  belongs_to :tag, optional: true
  belongs_to :user
  has_many :event_dates
  has_many :event_weeklies

  def impact_cleaner
    if impact == "in"
      return "Will Pay"
    elsif impact == "out"
      return "Will Receive"
    end
  end

  def self.find_monthly_events(date, user)
    joins(:event_dates).where('event_dates.date' => date).where(user: user)
  end

  def self.find_weekly_events(date, user)
    week = date.to_datetime.strftime("%U").to_i
    day = date.to_datetime.strftime("%A")
    joins(:event_weeklies).where('event_weeklies.week_number' => week, 'event_weeklies.' + day.downcase => true).where(user: user).each
  end

  def partial_week_update(date)
    day = date.wday

    if day == 1
        sunday = false
      elsif day == 2
        sunday = false
        monday = false
      elsif day == 3
        sunday = false
        monday = false
        tuesday = false
      elsif day == 4
        sunday = false
        monday = false
        tuesday = false
        wednesday = false
      elsif day == 5
        sunday = false
        monday = false
        tuesday = false
        wednesday = false
        thursday = false
      elsif day == 6
        sunday = false
        monday = false
        tuesday = false
        wednesday = false
        thursday = false
        friday = false
      end
  end

  def beg_week_delete(date)
    day = date.wday

    if day == 6
      saturday = false
    elsif day == 5
      saturday = false
      friday = false 
    elsif day == 4
      saturday = false
      friday = false
      thursday = false
    elsif day == 3
      saturday = false
      friday = false
      thursday = false
      wednesday = false
    elsif day == 2
      saturday = false
      friday = false
      thursday = false
      wednesday = false
      tuesday = false
    elsif day == 1
      saturday = false
      friday = false
      thursday = false
      wednesday = false
      tuesday = false
      monday = false
    elsif day == 0
      saturday = false
      friday = false
      thursday = false
      wednesday = false
      tuesday = false
      monday = false
      sunday = false
    end
  end

end
