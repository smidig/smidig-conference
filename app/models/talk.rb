class Talk < ActiveRecord::Base
  belongs_to :speaker, :class_name => "User"
  belongs_to :topic
  has_many :comments, :order => "created_at", :include => :user
  has_many :votes
  
  validates_acceptance_of :accepted_guidelines
  validates_presence_of :allow_derivatives
  
  def topic_name
    topic.title
  end
  
  def license
    "by#{allow_commercial_use ? '' : '-nc'}#{allow_derivatives.blank? ? '' : '-' + allow_derivatives}"
  end
end
