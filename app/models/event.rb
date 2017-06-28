class Event < ApplicationRecord
  validates :date, :repeat, :amount, :impact, presence: true
  validates :amount, numericality: {only_decimal: true}

  belongs_to :tag, optional: true
  belongs_to :user
  has_many :event_dates
  has_many :event_dates

  def impact_cleaner
    if impact == "in"
      return "Will Pay"
    elsif impact == "out"
      return "Will Receive"
    end
  end

#work around to match Calendar Gem
    def start_time
        self.date 
    end

end
