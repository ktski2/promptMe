class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :destroy]
  before_action :correct_user, only: [:show]
  before_action :admin_user_here,     only: :destroy

  def show
    remove_post_id if new_user_post?
    @user = User.find(params[:id])
    # @posts = @user.posts.all
    @posts = @user.posts.order(created_at: :asc).page(params[:page]).per(5)
    respond_to do |format|
      format.html
    end
    #redirect_to root_url and return unless @user.authenticated?(:activation, @user.id)
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if session[:post_id]
        @post = Post.find(session[:post_id])
        @post.update_attribute(:user_id, @user.id)
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        redirect_to @user
      else
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
        redirect_to root_url
      end
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password,
                                   :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in? || session[:post_id]
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || (current_user && current_user.admin?) || session[:post_id]
    end

    # Confirms an admin user.
    def admin_user_here
      remove_post_id
      redirect_to(root_url) unless current_user && current_user.admin?
    end
end
