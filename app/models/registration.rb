class Registration < ActiveRecord::Base
  TICKET_TEXTS = {
    "early_bird" => "Earlybird-billett til Smidig 2009",
    "full_price" => "Billett til Smidig 2009",
    "sponsor" => "Sponsor Smidig 2009",
    "volunteer" => "Frivillig på Smidig 2009",
    "organizer" => "Arrangør på Smidig 2009",
    "speaker" => "Foredragsholder på Smidig 2009"
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
  
  def description      
    TICKET_TEXTS[self.ticket_type] + " " + (includes_dinner? ? 'inkludert middag' : 'uten middag') +
      (registration_complete ? " (Betalt)" : "")
  end
  
  def free_ticket
    %w(sponsor volunteer organizer speaker).include? ticket_type
  end
  
  def paid?
    payment_notification && payment_notification.status == "Completed"
  end
  
  def payment_url(payment_notifications_url, return_url)
  	values = {
      :business => PAYMENT_CONFIG[:paypal_email],
      :cmd => '_cart',
      :upload => '1',
      :currency_code => 'NOK',
      :notify_url => payment_notifications_url,
      :return => return_url,
      :invoice => id,
      :amount_1 => price,
      :item_name_1 => description,
      :item_number_1 => '1',
      :quantity_1 => '1'
    }
        
    PAYMENT_CONFIG[:paypal_url] +"?"+values.map do
          |k,v| "#{k}=#{CGI::escape(v.to_s)}"
    end.join("&")
  end
  
  def self.find_by_params(params)
    if params[:conditions]
      find(:all, :conditions => params[:conditions], :include => :user)
    elsif params[:filter]
      case params[:filter]
      when "skal_faktureres"
        return find(:all,
          :conditions => """
          (free_ticket = 0 or free_ticket is null) and
          (registration_complete = 0 or registration_complete is null) and
          (manual_payment = 0 or manual_payment is null)
          """,
          :include => :user)
      else
        return []
      end
    else
      find(:all, :include => :user)
    end
  end

protected
  def create_payment_info
    self.registration_complete = false
    self.price = PAYMENT_CONFIG[:prices][ticket_type].to_i
    self.price += PAYMENT_CONFIG[:prices]["dinner"].to_i if includes_dinner && !free_ticket
    self.free_ticket = price == 0
    return true
  end


end
