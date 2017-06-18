class Expense < ApplicationRecord
  validates :date, :amount, presence: true


  belongs_to :tag, optional: true
  belongs_to :user
end


