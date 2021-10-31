class User < ApplicationRecord
    has_secure_password

    has_many :posts, dependent: :destroy

    has_many :this_user_followed, class_name: "Follow", foreign_key: "follower_id"
    has_many :followees, through: :this_user_followed
    has_many :following_this_users, class_name: "Follow", foreign_key: "followee_id"
    has_many :followers, through: :following_this_users

    has_many :likes
    has_many :liked_posts, through: :likes, source: :post

    validates :name, uniqueness: { case_sensitive: false }, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true
    validates :password, presence: true, length: { minimum: 10 }, confirmation: { case_sensitive: true }

    def get_feed_post
        # ids = Follow.where(follower_id: session[:user_id]).pluck ('followee_id')
        ids = self.followees.pluck ('id')
        return Post.where(user_id: ids).order('created_at DESC')
    end

    def get_profile_post
        return self.posts.order('created_at DESC')
    end

end
