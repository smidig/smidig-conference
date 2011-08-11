# -*- encoding : utf-8 -*-
class AddTypeToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :talk_type_id, :integer
  end

  def self.down
    remove_column :talks, :talk_type_id
  end
end
