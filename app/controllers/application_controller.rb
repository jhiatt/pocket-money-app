class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def update_pocket
    if current_user
      current_user.account.pocket_money_update
    end
  end
end

