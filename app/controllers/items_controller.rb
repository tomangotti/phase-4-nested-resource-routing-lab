class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response


  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
      render json: item, status: :ok
    end
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      itemNew = Item.create(name: params[:name], description: params[:description], price: params[:price] )
      itemNew.user_id = user.id
      itemNew.save
      render json: itemNew, status: :created
    end
  end


  private

  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end

  def post_params
    params.permit[:name]
  end

end
