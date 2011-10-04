# -*- encoding : utf-8 -*-

class Registration < ActiveRecord::Base
  TICKET_TEXTS = {
    "early_bird" => "Earlybird-billett til Smidig 2011",
    "full_price" => "Billett til Smidig 2011",
    "sponsor" => "Sponsor Smidig 2011",
    "volunteer" => "Frivillig på Smidig 2011",
    "student" => "Studentbillett til Smidig 2011",
    "organizer" => "Arrangør på Smidig 2011",
    "speaker" => "Foredragsholder på Smidig 2011"
  }
  attr_accessible :comments, :includes_dinner, :description,
    :ticket_type, :free_ticket,
    :manual_payment, :invoice_address, :invoice_description
  default_scope :order => 'created_at desc'
  belongs_to :user
  has_one :payment_notification
  validates_presence_of :ticket_type
  # validates_presence_of :invoice_address, :if => Proc.new { |reg| reg.manual_payment }
  before_create :create_payment_info
  def ticket_description
    TICKET_TEXTS[self.ticket_type] || ticket_type
  end
  def ticket_price
    PAYMENT_CONFIG[:prices][ticket_type].to_i
  end
  def price_mva
    (self.price - price_ex_mva).to_i
  end
  def price_ex_mva
    self.price/1.25
  end
  def description
    ticket_description + (registration_complete ? " (Betalt)" : "")
  end
  def speaker?
    ticket_type == "speaker"
  end
  def free_ticket
    ticket_price == 0
  end
  def discounted_ticket?
  %w(student).include? ticket_type
  end
  def special_ticket?
    %w(sponsor volunteer organizer).include? ticket_type
  end
  def paid?
    paid_amount && paid_amount > 0
  end
  def self.find_by_invoice(invoice_id)
    if invoice_id =~ /^2011t?-(\d+)$/
    Registration.find($1.to_i)
  else
    raise "Invalid invoice_id #{invoice_id}"
  end
  end
  def invoice_id
    return "2011-#{id}" if Rails.env == "production"
    return "2011t-#{id}"
  end
  def payment_url(payment_notifications_url, return_url)
    values = {
      :business => PAYMENT_CONFIG[:paypal_email],
      :cmd => '_cart',
      :upload => '1',
      :currency_code => 'NOK',
      :notify_url => payment_notifications_url,
      :return => return_url,
      :invoice => invoice_id,
      :amount_1 => price,
      :item_name_1 => description,
      :item_number_1 => '1',
      :quantity_1 => '1'
    }
    PAYMENT_CONFIG[:paypal_url] +"?"+values.map do
          |k,v| "#{k}=#{CGI::escape(v.to_s)}"
    end.join("&")
  end
  def status
    paid? ? "Betalt" : (
      registration_complete? ? "Godkjent" : (
        manual_payment? && !invoiced ? "Skal faktureres" : (
          manual_payment? ? "Har blitt fakturert" : "Må følges opp")))
  end
  def self.find_by_params(params)
    if params[:conditions]
      find(:all, :conditions => params[:conditions], :include => :user)
    elsif params[:filter]
      case params[:filter]
      when "skal_foelges_opp"
        return find(:all,
          :conditions => { :free_ticket => false , :registration_complete => false, :manual_payment => false},
          :include => :user)
      when "skal_faktureres"
        return find(:all,
          :conditions => { :free_ticket => false , :registration_complete => false, :manual_payment => true, :invoiced => false},
          :include => :user)
      when "dinner"
        return find(:all, :conditions => "includes_dinner = 1")
      else
        return []
      end
    else
      find(:all, :include => :user)
    end
  end
  def create_payment_info
    if paid?
      raise "Kan ikke endre en utført betaling!"
    end
    self.registration_complete = false
    self.price = ticket_price
    self.free_ticket = price == 0
    return true
  end
end