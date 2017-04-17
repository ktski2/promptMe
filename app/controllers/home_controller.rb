class HomeController < ApplicationController
  def index
    remove_post_id if new_user_post?
  	# @prompts = Prompt.all
    @prompts = Prompt.order(created_at: :asc).page(params[:page]).per(2)
  end
end
