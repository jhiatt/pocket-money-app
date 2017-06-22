class PagesController < ApplicationController
  before_action :authenticate_user!
  def index
    @expense = Expense.new(date: Time.now)
    if current_user && current_user.tags.any?
      @tags = Tag.where(user_id: current_user.id)
      current_user.account.pocket_money_update
    elsif current_user
      @tags = []
    else
      redirect_to "/users/sign_in"
    end
  end

end
