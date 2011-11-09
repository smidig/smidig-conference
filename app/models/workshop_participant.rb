# -*- encoding : utf-8 -*-
class WorkshopParticipant < ActiveRecord::Base
  belongs_to :user
  belongs_to :talk
  validates_uniqueness_of :talk_id, :scope => :user_id

  def self.max_participants_per_workshop
    20
  end
end

