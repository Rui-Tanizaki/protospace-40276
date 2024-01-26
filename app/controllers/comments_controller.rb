class CommentsController < ApplicationController

  def create
    @comment = Comment.create(comment_params)
    if @comment.save
      redirect_to prototype_path(params[:prototype_id]), notice: 'コメントが投稿されました。'
    else
      @prototype = Prototype.find(params[:prototype_id])
      @comment.user_id = @prototype.user_id
      redirect_to prototype_path(@prototype)
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end

end
