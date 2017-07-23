class TagsController < ApplicationController
  def index
    @tags = Tag.where(user_id: current_user.id)
    render "index.html.erb"
  end

  def new
  end

  def create
  end

  def destroy
    tag = Tag.find_by(id: params[:id])
    tag.destroy
    redirect_to "/tags"
  end
end
