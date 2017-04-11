class PostsController < ApplicationController
  def create
    @prompt = Prompt.find(params[:post][:prompt_id])
    @post = @prompt.posts.create(post_params)
    @post.user_id = current_user.id
    #respond_to do |format|
      if @post.save
    #    format.html { redirect_to current_user }
    #    format.js { }
    #    format.json { render :show, status: :created, location: current_user }
        flash.now[:success] = "you saved it somehow kt"
        #f.js
      else
    #  	format.html { render :new }
    #    format.json { render json: @post.errors, status: :unprocessable_entity }
        flash.now[:danger] = "error"
        #f.js
   # end
end
  end

  private

    def post_params
      params.require(:post).permit(:user_id, :prompt_id, :content)
    end
end
