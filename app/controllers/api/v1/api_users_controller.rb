class Api::V1::ApiUsersController < ApplicationController

  def new
  end

  def create
    ApiUser.create(email: params[:email])
    render "new.html.erb"
  end

end
