class Talk < ActiveRecord::Base
  belongs_to :speaker, :class_name => "User"
  belongs_to :topic
  has_many :comments, :order => "created_at", :include => :user
  has_many :votes
  
  def topic_name
    topic.title
  end
end
