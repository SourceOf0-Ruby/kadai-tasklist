class UsersController < ApplicationController
  
  # ログイン時のみ表示するページを指定
  before_action :require_user_logged_in, only: [:show, :update, :edit];
  
  
  def show
    @user = User.find(params[:id]);
    @tasks = @user.tasks.order('updated_at DESC').page(params[:page]);
    count_remained_tasks(@user);
  end

  def new
    @user = User.new;
  end

  def create
    @user = User.new(user_params);
    
    if @user.save
      # ユーザ作成と同時にログイン状態にする
      session[:user_id] = @user.id;
      
      flash[:success] = 'ユーザを登録しました。';
      redirect_to root_url;
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。';
      render :new;
    end
  end
  

  private
  # 以下privateメンバ
  
  # Strong Paramter
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation);
  end
  
end
