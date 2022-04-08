class UserMailer < ApplicationMailer

  def notice_mail
    @user = User.find(params[:member_id])
    @owner = User.find(params[:owner_id])
    @group = Group.find(params[:group_id])
    @notice = Notice.find(params[:notice_id])
    mail(to: @user.email, subject: @notice.title)
  end
end
