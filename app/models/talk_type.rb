# -*- encoding : utf-8 -*-
class TalkType < ActiveRecord::Base
  has_many :talks
  
  def name_and_duration
    "#{name} (#{duration})"
  end

end
