# -*- encoding : utf-8 -*-

class Talk < ActiveRecord::Base
  default_scope :order => 'acceptance_changed_at desc, created_at desc'

  scope :workshops, joins(:talk_type).where(:talk_types => {:name => ['Kort workshop','Lang workshop']})

  has_many :speakers
  has_many :workshop_participants
  has_many :participants, :through => :workshop_participants, :source => :user
  has_many :users, :through => :speakers
  belongs_to :period
  has_many :comments, :order => "created_at", :include => :user
  has_many :votes, :include => :user
  has_and_belongs_to_many :tags
  has_many :feedback_comments
  belongs_to :talk_type

  has_attached_file :slide, PAPERCLIP_CONFIG

  validates_presence_of :title, :description
  #validates_attachment_content_type :slide, :content_type => ['application/pdf', 'application/vnd.ms-powerpoint', 'application/ms-powerpoint', %r{application/vnd.openxmlformats-officedocument}, %r{application/vnd.oasis.opendocument}, 'application/zip', 'application/x-7z-compressed', 'application/x-gtar']

  validates_attachment_size :slide, :less_than => 20.megabytes

  validates_acceptance_of :accepted_guidelines
  validates_acceptance_of :accepted_cc_license

  def speaker_name
    users.map(&:name).join(", ")
  end

  def speaker_company
    users.map(&:company).join(", ")
  end

  def speaker_email
    users.map(&:email).join(", ")
  end


  def option_text
    %Q[#{id} - "#{trunc(title, 30)}" (#{trunc(speaker_name, 20)})]
  end

  def trunc(text, length)
    (text.length < length + 3) ? text : "#{text.first(length)}..."
  end

  def describe_audience_level
    case audience_level
      when 'novice' then
        'De som har hørt om smidig'
      when 'intermediate' then
        'De som har prøvd smidige metoder'
      when 'expert' then
        'De som bruker smidige metoder i dag'
      else
        ''
    end
  end

  def license
    "by"
  end

  def workshop?
    !talk_type.nil? && talk_type.name.include?('workshop')
  end

  def participant?(user)
    participant_ids.include?(user.id)
  end

  def complete?
    participant_ids.count >= max_participants
  end

  def free_places
    max_participants - participant_ids.count 
  end

  def self.all_pending_and_approved
    all(:order => 'id desc', :include => {:users => :registration}).select {
            |t| !t.refused? && !t.users.first.nil? && t.users.first.registration.ticket_type = "speaker"
    }
  end

  def self.all_pending_and_approved_tag(tag)
    talks_tmp = all(:order => 'id desc', :include => {:users => :registration}).select {
            |t| !t.users.first.nil? && t.users.first.registration.ticket_type = "speaker"
    }
    talks = []
    talks_tmp.each do |talk|
      if talk.tags.include? tag
         talks.push talk
      end
    end
    talks
  end

  def self.all_accepted
    all(:include => :period, :conditions => "acceptance_status = 'accepted'")
  end

  def self.all_with_speakers
    with_exclusive_scope { find(:all, :include => :users, :order => "users.name ") }
  end

  def email_is_sent?
    email_sent
  end


  def accept!
    self.acceptance_status = "accepted"
    self.acceptance_changed_at = Time.now
    self
  end

  def accepted?
    self.acceptance_status == "accepted"
  end

  def pending?
    self.acceptance_status == "pending"
  end

  def refused?
    self.acceptance_status == "refused"
  end

  def refuse!
    self.acceptance_status = "refused"
    self.acceptance_changed_at = Time.now
    self
  end

  def regret!
    self.acceptance_status = "pending"
    self
  end

  def average_feedback_score
    score = self.sum_of_votes.to_f / self.num_of_votes.to_f
    "%.2f" % score
  end

  def self.add_feedback(talk_id, sum, num)
    talk = Talk.find(talk_id, :include => :users)
    puts "Gir stemmer til talken til " + talk.speaker_name
    talk.sum_of_votes = sum
    talk.num_of_votes = num

    talk.save
  end

  def self.add_comment(talk_id, comment)
    comm = FeedbackComment.new
    comm.comment = comment
    comm.talk = Talk.find(talk_id)
    comm.save!
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

  def description_and_type
    "#{description}\n#{talk_type.name_and_duration}"
  end
end
