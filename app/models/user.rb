class User < ActiveRecord::Base
  default_scope :order => 'created_at desc'
  
  acts_as_authentic
  has_one :registration
  has_many :votes

  has_many :talks, :foreign_key => 'speaker_id'
    
  has_many :comments
  
  attr_accessible :name, :email, :password, :password_confirmation, :company,
  	:is_admin, :phone_number
  
  accepts_nested_attributes_for :registration
  
  validates_format_of :phone_number, :with => /\A(\d{8}|\d{3} \d{2} ?\d{3}|\d{2} \d{2} \d{2} \d{2})\Z/,
    :message => "må være på formen 999 99 999", :allow_nil => true
    
  validates_presence_of :name
  validates_uniqueness_of :email
  
  def self.find_with_filter(filter)
    case filter
    when "all","", nil
      return find(:all, :include => :registration)
    when "admin"
      return find(:all, :conditions => { :is_admin => true }, :include => :registration)
    when "speakers"
      return find(:all, :include => [:registration, :talks]).reject { |u| u.talks.empty? }
    when "paid"
      return find(:all, :include => :registration).select { |u| u.registration and u.registration.paid? }
    when "unpaid"
      return find(:all, :include => :registration).select { |u| u.registration and not u.registration.paid? }
    when "paying_speaker"
      return find(:all, :include => [:registration, :talks]).reject { |u| u.talks.empty? }.
        select { |u| u.registration and u.registration.paid? }
    else
      raise "Illegal filter #{filter}"
    end
  end
  
end
