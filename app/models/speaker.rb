# -*- encoding : utf-8 -*-
class Speaker < ActiveRecord::Base
  belongs_to :talk
  belongs_to :user
end
