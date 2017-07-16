class Api::V1::ExpensesController < ApplicationController
  def index
    @expenses = Expense.where(user_id: params[:id])
    render "index.json.jbuilder"
  end

  def create
    if params[:amount].to_f < 0
      amount = -params[:amount]
    else
      amount = params[:amount]
    end
    if params[:impact] == "out"
      amount = -amount
    end
    @expense = Expense.new(date: params[:date], amount: amount, user_id: params[:user_id])
    if params[:tag_id]
      @expense.tag_id = params[:tag_id]
    end
    @expense.save
    user = User.find_by(id: params[:user_id])
    user.account.pocket_money_update
    @account = user.account
    render "show.json.jbuilder"
  end
end
