class UsersController <ApplicationController 
  before_action :require_login, only: [:show]

  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
  end 

  def create 
    user = User.create(user_params)
    if user.save
      redirect_to user_path(user)
      session[:user_id] = user.id
    else  
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to register_path
    end 
  end 

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 

  def require_login
    unless current_user
      flash[:error] = "Please login or register to view your dashboard."
      redirect_to root_path
    end
  end
end 