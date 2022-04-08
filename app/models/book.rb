class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
	has_one :view_count, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
	validates :rate,presence:true,numericality: {
		less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
	}

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

	def self.post_count(num)
		target = (Time.current - num.day)
		Book.where(created_at: target.at_beginning_of_day...target.at_end_of_day).count
	end
end