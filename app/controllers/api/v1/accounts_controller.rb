class Api::V1::AccountsController < ApplicationController

  def show
    @account = Account.find_by(id: params[:id])
    puts @account
    render "show.json.jbuilder"
  end

  def update
    @account = Account.find_by(id: params[:id])
    if params[:pocket_time] = "" || params[:pocket_time] = 0
      pocket_time = @account.pocket_time
    else
      pocket_time = params[:pocket_time] 
    end
    @account.update(last_balance: params[:last_balance], pocket_time: pocket_time, balance_update_time: Time.now)
    @account.pocket_money_update

    render "show.json.jbuilder"
  end

end
