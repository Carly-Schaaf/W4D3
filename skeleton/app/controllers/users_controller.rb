class UsersController < ApplicationController
  def new
    render :new
  end
  
  def create
    user = User.new(strong_params)
    user.save!
        debugger
    log_in!(user)
    redirect_to cats_url
  end
  
  private
  
  def strong_params
    params.require(:user).permit(:username, :password)
  end
end