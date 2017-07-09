class Api::V1::TagsController < ApplicationController

  def index
    @tags = Tag.where(user_id: params[:id])
    render "index.json.jbuilder"
  end

  def create
    @tag = Tag.create(user_id: params[:user_id], description: params[:description])
    @account = User.find_by(id: params[:user_id]).account
    render "show.json.jbuilder"
  end

end
