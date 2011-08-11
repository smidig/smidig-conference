# -*- encoding : utf-8 -*-
class AddNewWorkshopTypes < ActiveRecord::Migration
  def self.up
    TalkType.where(:name => "Workshop").first.destroy

    TalkType.new(:name => "Kort workshop", :duration => "45 minutter").save!
    TalkType.new(:name => "Lang workshop", :duration => "90 minutter").save!
  end

  def self.down
    TalkType.where(:name => "Lang workshop").first.destroy
    TalkType.where(:name => "Kort workshop").first.destroy

    TalkType.new(:name => "Workshop", :duration => "90 minutter").save!
  end
end
