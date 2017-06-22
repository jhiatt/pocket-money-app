class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :create_account
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tags
  has_many :events
  has_many :expenses
  has_one :account

  before_create :set_pocket_time



  def create_account
    Account.create(user_id: self.id, pocket_time: 30, last_balance: 0, pocket_money: 0)
  end
  
end
