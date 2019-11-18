class PostsController < ApplicationController
  def create
    remove_post_id if new_user_post?
    @prompt = Prompt.find(params[:post][:prompt_id])
    @post = @prompt.posts.create(post_params)
    respond_to do |format|
      if @post.save
        if !current_user
          store_post_id(@post.id)
          format.html { redirect_to signup_url }
        else
          @post.user_id = current_user.id
          format.html { redirect_to current_user }
        end
      else
        flash.now[:danger] = "error saving post"
        format.html { redirect_to signup_url }
      end
    end
  end

  def download
    @prompt = params[:pprompt]
    @post = params[:ptext]
    html = render_to_string(:partial => 'download', :layout => false, :locals => {prompt: @prompt, post: @post})
    pdf = WickedPdf.new.pdf_from_string(html)
    send_data(pdf,
        :filename    => "promptMe.pdf",
        :disposition => 'attachment')
  end

  private

    def post_params
      params.require(:post).permit(:user_id, :prompt_id, :content)
    end
end
