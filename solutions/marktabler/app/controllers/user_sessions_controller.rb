class UserSessionsController < ApplicationController

  def new
  end

  def create
    user = login(params[:email], params[:password])

    if user
      redirect_back_or_to root_url, :notice => "Logged in!"
    else
      flash[:alert] = "Email or password was invalid."
      redirect_to :login
    end

    session[:cart_id] = current_cart.id
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end

end
