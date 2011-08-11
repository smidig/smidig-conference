# -*- encoding : utf-8 -*-
class CreatePeriods < ActiveRecord::Migration
  def self.up
    create_table :periods do |t|
      t.integer :time_id
      t.integer :scene_id
      t.integer :topic_id
      t.integer :topic_offset

      t.timestamps
    end
  end

  def self.down
    drop_table :periods
  end
end
