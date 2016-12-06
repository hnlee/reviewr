class Api::UsersController < Api::BaseController
  def show
    @user = User.find_by_id(params[:id]) 
    render json: @user 
  end
end
