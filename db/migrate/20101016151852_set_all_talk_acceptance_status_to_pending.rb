class SetAllTalkAcceptanceStatusToPending < ActiveRecord::Migration
  def self.up
    Talk.all.each do |talk|
      talk.acceptance_status = "pending"
      talk.save
    end
  end

  def self.down
  end
end
