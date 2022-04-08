class NoticesController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    if @group.owner_id == current_user.id
      @notice = Notice.new
    else
      redirect_to groups_path
    end
  end

  def create
    @notice = Notice.new(notice_params)
    @notice.owner_id = current_user.id
    if @notice.save
      group = Group.find(params[:group_id])
      group.users.each do |member|
        UserMailer.with(member_id: member.id, group_id: group.id, notice_id: @notice.id, owner_id: @notice.owner_id).notice_mail.deliver_later
      end
      redirect_to notice_path(@notice)
    else
      render :new_notice
    end
  end

  def show
    @notice = Notice.find(params[:id])
  end

  private
  
  def notice_params
    params.require(:notice).permit(:title, :content)
  end
end
