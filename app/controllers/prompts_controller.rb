class PromptsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :admin_user,     only: [:new, :create, :destroy]

  def new
  	@prompt = Prompt.new
  end

  def create
    @prompt = Prompt.new(prompt_params)
    if @prompt.save
      flash[:success] = "Prompt created!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
  end

  private

    def prompt_params
      params.require(:prompt).permit(:content)
    end
end
