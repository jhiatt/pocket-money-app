class PagesController < ApplicationController

  def index
    @expense = Expense.new(date: Time.now)
    if current_user && current_user.tags.any?
      @tags = Tag.where(user_id: current_user.id)
    elsif current_user
      @tags = []
    else
      redirect_to "/users/sign_in"
    end
    current_user.pocket_money_update
  end

end
