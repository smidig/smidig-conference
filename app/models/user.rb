class User < ActiveRecord::Base
  acts_as_authentic
  has_one :registration
  has_many :votes

  has_many :talks, :foreign_key => 'speaker_id'
    
  has_many :comments
  
  attr_accessible :name, :email, :password, :password_confirmation, :company,
  	:is_admin, :phone_number
  
  accepts_nested_attributes_for :registration
  
  validates_format_of :phone_number, :with => /\A(\d{8}|\d{3} \d{2} ?\d{3}|\d{2} \d{2} \d{2} \d{2})\Z/,
    :message => "må være på formen 999 99 999"
    
  validates_presence_of :name
  
end
