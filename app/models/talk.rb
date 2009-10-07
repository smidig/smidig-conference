class Talk < ActiveRecord::Base
  default_scope :order => 'created_at desc'

  belongs_to :speaker, :class_name => "User"
  belongs_to :topic
  has_many :comments, :order => "created_at", :include => :user
  has_many :votes, :include => :user
  
  has_attached_file :slide
  
  validates_acceptance_of :accepted_guidelines  
  validates_acceptance_of :accepted_cc_license
  validates_presence_of :topic, :title, :description
  
  accepts_nested_attributes_for :speaker, :allow_destroy => false

  def topic_name
    topic.title
  end
  
  def describe_audience_level
    case audience_level
    when 'novice' then 'De som har hørt om smidig'
    when 'intermediate' then 'De som har prøvd smidige metoder'
    when 'expert' then 'De som bruker smidige metoder i dag'
    else ''
    end
  end
  
  def license
    "by"
  end
end
