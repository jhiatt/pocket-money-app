class PagesController < ApplicationController
  before_action :authenticate_user!

  #before action: check to see if roll forward is needed (maybe at the calendar too?)
    #popup also lets you know it will be less frequent if you extend pocket time
  # def index
  #   current_user.account.check_pocket_period
  #   @expense = Expense.new(date: Time.now)
  #   if current_user && current_user.tags.any?
  #     @tags = Tag.where(user_id: current_user.id)
  #     current_user.account.pocket_money_update
  #   elsif current_user
  #     @tags = []
  #   else
  #     redirect_to "/users/sign_in"
  #   end
  # end

end
