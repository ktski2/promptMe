class HomeController < ApplicationController
  def index
    remove_post_id if new_user_post?
  	# @prompts = Prompt.all
    @prompts = Prompt.order(created_at: :asc).page(params[:page]).per(2)
  end

  def random_post
    @user = User.find(params[:user_id])
    @prompt = Prompt.offset(rand(Prompt.count)).first

    respond_to do |format|
      format.json {render json: @prompt}
    end
  end
end
