class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :followed_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followeds, through: :followed_relationships
  has_many :follower_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def followed?(other_user)
    self.followeds.include?(other_user)
  end

  def follow(other_user)
    self.followed_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    self.followed_relationships.find_by(followed_id: other_user.id).destroy
  end

  def self.search(search,word)
    if search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "perfect_match"
      @user = User.where("#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  def post_book_cnt(type)
    to = Time.current.at_end_of_day
    case type
    when 'today'
      from  = Time.current.at_beginning_of_day

    when 'yesterday'
      to    = (Time.current - 1.day).at_end_of_day
      from  = (Time.current - 1.day).at_beginning_of_day

    when 'this_week'
      from  = (Time.current - 6.day).at_beginning_of_day

    when 'last_week'
      to = (Time.current - 6.day).at_end_of_day
      from = (to - 6.day).at_beginning_of_day
    
    else
      from = Time.current.at_beginning_of_day
    end
    Book.where(user_id: self.id, created_at: from...to).count
	end
end
