class HomeController < ApplicationController
  def index
  	@prompts = Prompt.all
  	#@prompt = Prompt.find(params[:id])
  	#@post = Post.new
  end
end
