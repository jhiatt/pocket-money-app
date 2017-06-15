class Expense < ApplicationRecord
  validates :date, :amount, :user_id, presence: true


  belongs_to :tag, optional: true
  belongs_to :user
end


