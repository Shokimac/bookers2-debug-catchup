class BooksController < ApplicationController

  def show
    view_count = ViewCount.find_or_create_by!(book_id: params[:id])
    view_count.increment!(:count)

    @new_book = Book.new
    @book = Book.find(params[:id])
    @new_comment = BookComment.new
  end

  def index
    @book = Book.new
    to  = Time.current.at_end_of_day
    from    = (to - 6.day).at_beginning_of_day
    @books = Book.left_joins(:favorites).where(created_at: from...to).group('books.id').order('count(favorites.book_id) DESC')

    @post_cnt = []
    for num in 0..6 do
      @post_cnt[num] = Book.post_count(num)
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def count
    @count = current_user.post_count_day(params[:user_id], params[:date])
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
