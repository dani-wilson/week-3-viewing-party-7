class SessionsController < ApplicationController
  def new
  end

  def create
    if !params[:email] || !params[:password] || params[:password] != params[:password_confirmation] 
      flash[:error] = "Invalid credentials"
      render :new
    else
      @user = User.find_by(email: params[:email].downcase)

      if @user.nil?
        flash[:error] = "Invalid credentials"
        render :new
      elsif @user.authenticate(params[:password])
          session[:user_id] = @user.id
          flash[:success] = "Welcome, #{@user.name}"
          redirect_to user_path(@user.id)
      else 
        flash[:error] = "Invalid credentials"
        render :new
      end
    end
  end

  def destroy
    session.delete(:user_id)
    @user = nil
    redirect_to root_path
  end
end