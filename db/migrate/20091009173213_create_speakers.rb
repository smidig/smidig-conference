# -*- encoding : utf-8 -*-
class CreateSpeakers < ActiveRecord::Migration
  def self.up
    create_table :speakers do |t|
      t.integer :talk_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :speakers
  end
end
