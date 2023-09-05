class UsersController <ApplicationController 
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

  def login_form
  end

  def login
    if !params[:email] || !params[:password] || params[:password] != params[:password_confirmation] 
      flash[:error] = "Invalid credentials"
      render :login_form
    else
      @user = User.find_by(email: params[:email])

      if @user.nil?
        flash[:error] = "Invalid credentials"
        render :login_form
      elsif @user.authenticate(params[:password])
          session[:user_id] = @user.id
          flash[:success] = "Welcome, #{@user.name}"
          redirect_to user_path(@user.id)
      else 
        flash[:error] = "Invalid credentials"
        render :login_form
      end
    end
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 
end 