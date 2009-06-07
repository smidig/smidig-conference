class User < ActiveRecord::Base
  acts_as_authentic
  has_one :registration
  has_many :votes

  has_many :talks, :foreign_key => 'speaker_id'
    
  has_many :comments
  
  attr_accessible :name, :email, :password, :password_confirmation, :company,
  	:is_admin
  
  accepts_nested_attributes_for :registration
end
