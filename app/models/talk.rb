class Talk < ActiveRecord::Base
  default_scope :order => 'created_at desc'

  belongs_to :speaker, :class_name => "User"
  belongs_to :topic
  has_many :comments, :order => "created_at", :include => :user
  has_many :votes
  
  validates_acceptance_of :accepted_guidelines  
  validates_acceptance_of :accepted_cc_license
  validates_presence_of :topic, :title, :description
  
  accepts_nested_attributes_for :speaker, :allow_destroy => false

  def topic_name
    topic.title
  end
  
  def license
    # "by#{allow_commercial_use ? '' : '-nc'}#{allow_derivatives.blank? ? '' : '-' + allow_derivatives}"
    "by"
  end
end
