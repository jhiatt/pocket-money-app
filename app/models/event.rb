class Event < ApplicationRecord
  validates :date, :repeat, :amount, :impact, presence: true
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

end
