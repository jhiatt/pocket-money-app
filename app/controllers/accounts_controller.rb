class AccountsController < ApplicationController

  def edit
  end

  def update
    account = Account.find_by(id: params[:id])
    account.update(last_balance: params[:last_balance], pocket_time: params[:pocket_time])
    account.pocket_money_update
    redirect_to "/"
  end

end
