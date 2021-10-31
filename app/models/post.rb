class Post < ApplicationRecord
  belongs_to :user

  has_many :likes
  has_many :like_users, through: :likes, source: :user

  def get_like_user_names
    return self.like_users.order('name').pluck ('name')
  end

  def get_like_user_name_links
    data = ""
    self.get_like_user_names.each do |n|
      data << "<a href='/profile/#{n}' style='font-size: large;'>#{n}</a></br>"
    end
    return data
  end


  def this_user_liked(user_id)
    return self.like_users.include?(User.find_by(id: user_id))
  end

end
