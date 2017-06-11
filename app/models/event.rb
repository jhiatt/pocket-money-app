class Event < ApplicationRecord
  validates :date, :frequency, :amount, :impact, presence: true
  validates :amount, numericality: {only_integer: true}

#can we do every month on X date? can we do every two weeks or once every two months?
  # def repeat
  #   if params:[frequency] == "Monthly"
  #     1
  #   end
  # end

end
