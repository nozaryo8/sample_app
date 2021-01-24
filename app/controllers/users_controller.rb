class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user #8.29追加　ユーザー登録後ログイン　
      #↑ /sample_app/app/helpers/sessions_helper.rbのメソッド
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
