class UpdatePeriodsWithTime < ActiveRecord::Migration
  def self.up
    Period.update_all "time_of_day = '9:00-9:45', day = 'torsdag'", :time_id => 0
    Period.update_all "time_of_day = '10:00-10:45', day = 'torsdag'", :time_id => 1
    Period.update_all "time_of_day = '11:00-11:45', day = 'torsdag'", :time_id => 2
    Period.update_all "time_of_day = '9:00-9:45', day = 'fredag'", :time_id => 3
    Period.update_all "time_of_day = '10:00-10:45', day = 'fredag'", :time_id => 4
    Period.update_all "time_of_day = '11:00-11:45', day = 'fredag'", :time_id => 5
  end

  def self.down
  end
end
