class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      GroupUser.new(user_id: current_user.id, group_id: @group.id).save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @new_book = Book.new
  end

  def edit
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to group_path(@group)
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render 'edit'
    end
  end
  
  def join
    group_user = GroupUser.new(user_id: current_user.id, group_id: params[:group_id])
    group_user.save
    redirect_to groups_path
  end

  def leave
    group_user = GroupUser.where(group_id: params[:group_id]).find_by(user_id: current_user.id)
    group_user.destroy
    redirect_to groups_path
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
