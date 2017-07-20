class Api::V1::ExpensesController < ApplicationController
  # after_action :update_pocket, only: [:create, :update, :destroy]

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
    # user.account.pocket_money_update
    user.account.pocket_money += @expense.amount
    user.account.save
    # @account.pocket_money_update
    render "show.json.jbuilder"
  end

  #update pocket money
  def update
  end

  def destroy
    expense = Expense.find_by(id: params[:id])
    user = expense.user
    expense.delete
    update_pocket(user.id)
    render "index.json.jbuilder"
  end

  def update_pocket(user_id)
    account = Account.find_by(user_id: user_id)
    account.pocket_money_update
  end
end
