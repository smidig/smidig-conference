class Topic < ActiveRecord::Base
  has_many :talks, :order => "position", :include => :speaker
end
