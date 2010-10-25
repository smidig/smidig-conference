class Talk < ActiveRecord::Base
  default_scope :order => 'created_at desc'

  has_many :speakers
  has_many :users, :through => :speakers
  belongs_to :period
  has_many :comments, :order => "created_at", :include => :user
  has_many :votes, :include => :user
  has_and_belongs_to_many :tags

  has_attached_file :slide, PAPERCLIP_CONFIG

  #validates_attachment_content_type :slide, :content_type => ['application/pdf', 'application/vnd.ms-powerpoint', 'application/ms-powerpoint', %r{application/vnd.openxmlformats-officedocument}, %r{application/vnd.oasis.opendocument}, 'application/zip', 'application/x-7z-compressed', 'application/x-gtar']

  validates_attachment_size :slide, :less_than => 20.megabytes

  validates_acceptance_of :accepted_guidelines
  validates_acceptance_of :accepted_cc_license

  def accept!
    self.acceptance_status = "accepted"
    self
  end
  def accepted?
    self.acceptance_status == "accepted"
  end

  def speaker_name
    users.map(&:name).join(", ");
  end


  def option_text
    %Q[#{id} - "#{trunc(title, 30)}" (#{trunc(speaker_name, 20)})]
  end

  def trunc(text, length)
    (text.length < length + 3) ? text : "#{text.first(length)}..."
  end

  def describe_audience_level
    case audience_level
    when 'novice' then 'De som har hørt om smidig'
    when 'intermediate' then 'De som har prøvd smidige metoder'
    when 'expert' then 'De som bruker smidige metoder i dag'
    else ''
    end
  end

  def license
    "by"
  end

  def self.all_pending_and_approved
    all(:order => 'id desc', :include => { :users => :registration }).select {
      |t| !t.users.first.nil? && t.users.first.registration.ticket_type = "speaker"
    }
  end
  
  def self.all_pending_and_approved_tag(tag)
    all(:order => 'id desc', :include => { :users => :registration }).select {
      |t| !t.users.first.nil? && t.users.first.registration.ticket_type = "speaker"
    }
  end

  def self.all_with_speakers
    with_exclusive_scope{ find(:all, :include => :users, :order => "users.name ")}
  end

  def email_is_sent?
    email_sent 
  end

  def pending?
    self.acceptance_status == "pending"
  end
 def refused?
    self.acceptance_status == "refused"
  end

  def refuse!
    self.acceptance_status = "refused"
    self
  end

  def regret!
    self.acceptance_status = "pending"
    self
  end

  def self.count_accepted
    self.count(:conditions => "acceptance_status = 'accepted'")
  end

  def self.count_refused
    self.count(:conditions => "acceptance_status = 'refused'")
  end

  def self.count_pending
    self.count(:conditions => "acceptance_status = 'pending'")
  end

end
