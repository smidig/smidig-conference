class User < ActiveRecord::Base
  acts_as_authentic
  has_one :registration
  
  accepts_nested_attributes_for :registration
end
