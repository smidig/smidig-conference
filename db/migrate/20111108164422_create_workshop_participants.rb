# -*- encoding : utf-8 -*-
class CreateWorkshopParticipants < ActiveRecord::Migration
  def self.up
      create_table :workshop_participants do |t|
          t.references :user
          t.references :talk
          t.timestamps
      end
  end

  def self.down
      drop_table :workshop_participants
  end
end
