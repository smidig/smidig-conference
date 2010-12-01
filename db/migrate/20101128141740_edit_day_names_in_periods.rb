class EditDayNamesInPeriods < ActiveRecord::Migration
  def self.up
    Period.all.each do |period|
      period.day = "tirsdag" if period.day == "torsdag"
      period.day = "onsdag" if period.day == "fredag"
      period.save
    end
  end

  def self.down
  end
end
