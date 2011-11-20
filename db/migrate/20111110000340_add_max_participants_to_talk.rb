class AddMaxParticipantsToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :max_participants, :integer, :default => 20, :null => false
  end

  def self.down
    remove_column :talks, :max_participants
  end
end
