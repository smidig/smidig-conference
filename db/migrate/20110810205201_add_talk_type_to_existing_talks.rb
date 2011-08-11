# -*- encoding : utf-8 -*-
class AddTalkTypeToExistingTalks < ActiveRecord::Migration
  def self.up
  Talk.update_all(["talk_type_id = ?", 1])
  end

  def self.down
  end
end
