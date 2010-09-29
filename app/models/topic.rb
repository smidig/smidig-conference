class Topic < ActiveRecord::Base
  # has_many :talks, :order => "position", :include => :users
  validates_presence_of :title, :description
end
