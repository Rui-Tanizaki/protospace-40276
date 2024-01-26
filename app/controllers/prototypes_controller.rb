class PrototypesController < ApplicationController
  before_action :move_to_index, except: [:index, :show]

  def index
    @users = User.all
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end
  
  def edit
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && current_user == @prototype.user
      redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if prototype_params_changed? && @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      # 保存に成功した場合の処理
      redirect_to root_path
    else
      # 保存に失敗した場合の処理
      render :new,locals: { prototype: @prototype }
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile, :occupation, :position)
  end

  def prototype_params
     params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index

    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def prototype_id
    prototype_id = params[:id]
    @prototype = Prototype.find(prototype_id)
  end

  def prototype_params_changed?
    # 変更があるかどうか確認
    prototype_params.to_h.any? { |key, value| @prototype[key.to_sym] != value }
  end

end
