class Tag < ActiveRecord::Base
  has_and_belongs_to_many :talks
  validates_presence_of :title
  validates_uniqueness_of :title
end