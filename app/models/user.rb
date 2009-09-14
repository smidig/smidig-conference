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
  
  validates_format_of :phone_number, :with => /\A(\d{8}|\d{3} \d{2} ?\d{3}|\d{2} \d{2} \d{2} \d{2}|\(\+\d+\)[\d ]+)\Z/,
    :message => "må være på formen 999 99 999 eller (+99) 999999...", :allow_nil => true
  validates_length_of :phone_number, :in => 8..30
    
  validates_presence_of :name
  validates_uniqueness_of :email
  
  def user_status
    if not talks.empty?
      "Foredragsholder" + (registration && registration.paid? ? " *" : "")
    elsif registration
      (registration.paid? ? "Betalt " : "Ikke betalt ") + registration.price.to_s
    elsif is_admin
      "Administrator"
    else
      "Ukjent"
    end
  end
  
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
      return find(:all, :include => :registration).select { |u| u.registration and not u.registration.paid? and u.talks.empty? }
    when "paying_speaker"
      return find(:all, :include => [:registration, :talks]).reject { |u| u.talks.empty? }.
        select { |u| u.registration and u.registration.paid? }
    else
      raise "Illegal filter #{filter}"
    end
  end
  
end
