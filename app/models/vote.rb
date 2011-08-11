# -*- encoding : utf-8 -*-
class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :talk, :counter_cache => true
  validates_uniqueness_of :talk_id, :scope => :user_id
end
