class BookCommentsController < ApplicationController
  def create
    comment = current_user.book_comments.new(comment_params)
    comment.book_id = params[:book_id]
    comment.save
    redirect_to request.referer
  end

  def destroy
    comment = BookComment.find_by(params[:id])
    if comment.user == current_user
      comment.destroy
    end
    redirect_to request.referer
  end

  private
  def comment_params
    params.require(:book_comment).permit(:comment)
  end
end
