class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
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

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
