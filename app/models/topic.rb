class Topic < ActiveRecord::Base
  has_many :talks, :order => "position", :include => :speaker
  validates_presence_of :title, :description
end
