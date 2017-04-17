class HomeController < ApplicationController
  def index
    remove_post_id if new_user_post?
  	@prompts = Prompt.all
  	#@prompt = Prompt.find(params[:id])
  	#@post = Post.new
  end
end
