class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
  end
  def new
    @expense = Expense.new(date: Time.now)
  end
  def create
    @expense = Expense.new(date: )
  end
  def show
    @expense = Expense.find_by(id: params[:id])
  end
  def edit
  end
  def update
  end
  def destroy
  end
end
