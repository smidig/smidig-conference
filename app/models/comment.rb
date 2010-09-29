class Comment < ActiveRecord::Base
  belongs_to :user  
  belongs_to :talk, :counter_cache => true
  validates_presence_of :title, :description

  default_scope :order => 'created_at desc', :limit => 100, :include => [:talk, :user]
end
