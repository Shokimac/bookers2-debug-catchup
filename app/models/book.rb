class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
	has_one :view_count, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search(search,word)
		if search == "forward_match"
			@book = Book.where("title LIKE?","#{word}%")
		elsif search == "backward_match"
			@book = Book.where("title LIKE?","%#{word}")
		elsif search == "perfect_match"
			@book = Book.where("#{word}")
		elsif search == "partial_match"
			@book = Book.where("title LIKE?","%#{word}%")
		else
			@book = Book.all
		end
	end

	# def self.order_by_favorites_count()
	# 	select("*, COUNT(*) AS favorites_count")
  #   .left_joins(:favorites)
  #   .group("book.id")
  #   .order(:likes_count => order)
	# end
end