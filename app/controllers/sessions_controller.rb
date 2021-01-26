class SessionsController < ApplicationController
  

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    #if user && user.authenticate(params[:session][:password])
    if user&.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user #ヘルパーメソッド
      #remember user #ログインしてユーザーを保持する 9.7 /sample_app/app/models/user.rbのメソッド
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)#9.23 三項演算子
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? #9.16 ログイン中の場合実行する
    redirect_to root_url
  end

end
