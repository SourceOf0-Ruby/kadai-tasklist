class SessionsController < ApplicationController
  
  # ログイン画面
  def new
    # do nothing.
  end

  # ログイン要求
  def create
    email = params[:session][:email];
    password = params[:session][:password];
    if login(email, password)
      flash[:success] = 'ログインに成功しました。';
      redirect_to root_url;
    else
      flash.now[:danger] = 'ログインに失敗しました。';
      render 'new';
    end
  end

  # ログアウト要求
  def destroy
    session[:user_id] = nil;
    flash[:success] = 'ログアウトしました。';
    redirect_to root_url;
  end
  
  
  private
  # 以降privateメンバ
  
  # --------------------------------
  # ログイン処理を行う
  # @param email   : メールアドレス
  # @param password: パスワード
  # @return ログインに成功した場合はtrue、失敗した場合はfalse
  # 
  # @note ログイン成功時にはセッションを開始、対象ユーザを@userにセットする
  # --------------------------------
  def login(email, password)
    
    @user = User.find_by(email: email);
    
    if @user && @user.authenticate(password)
      # 該当ユーザが存在し、パスワードも一致した場合
      
      # セッション保存
      session[:user_id] = @user.id;
      
      # ログイン成功
      return true;
    else
      # ログイン失敗
      return false;
    end
    
  end

end
