class ExpensesController < ApplicationController
  before_action :authenticate_user!
  after_action :update_pocket, only: [:create, :update, :destroy]

  def index
    @expenses = Expense.all
  end
  # def new
  #   @expense = Expense.new(date: Time.now)
  # end
  def create
    if params[:pos_or_neg] == "In"
      amount = params[:amount].to_d.abs
    else amount = (params[:amount].to_d.abs * -1)
    end
    @expense = Expense.new(date: Time.now, tag_id: params[:tag_id], amount: amount, user_id: current_user.id)
    if @expense.save
      current_user.account.pocket_money_update
    end
    redirect_to "/expenses"
  end
  def show
    @expense = Expense.find_by(id: params[:id])
  end
  def edit
    @tags = Tag.where(user_id: current_user.id)
    @expense = Expense.find_by(id: params[:id])
  end
  def update
    expense = Expense.find_by(id: params[:id])
    expense.update(date: params[:date], amount: params[:amount], tag_id: params[:tag])
  end
  def destroy
    expense = Expense.find_by(id: params[:id])
    expense.destroy
    redirect_to "/expenses/index"
  end
  
  def update_pocket
    current_user.account.pocket_money_update
  end

end
