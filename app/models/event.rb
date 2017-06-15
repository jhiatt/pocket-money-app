class Event < ApplicationRecord
  validates :date, :frequency, :amount, :impact, presence: true
  validates :amount, numericality: {only_integer: true}

  belongs_to :tag, optional: true
  belongs_to :user


#By Jordan: can we do every month on X date? can we do every two weeks or once every two months?
  # def repeat
  #   if params:[frequency] == "Monthly"
  #     1
  #   end
  # end

  def impact_cleaner
    if impact == "in"
      return "Will Pay"
    elsif impact == "out"
      return "Will Receive"
    end
  end

end
