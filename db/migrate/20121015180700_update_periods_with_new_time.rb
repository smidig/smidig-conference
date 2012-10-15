# -*- encoding : utf-8 -*-
class UpdatePeriodsWithNewTime < ActiveRecord::Migration
  def self.up
    Period.update_all "time_of_day = '10:15-11:00', day = 'mandag'", :time_id => 0
    Period.update_all "time_of_day = '11:15-12:00', day = 'mandag'", :time_id => 1
    Period.update_all "time_of_day = '13:15-14:00', day = 'mandag'", :time_id => 2
    Period.update_all "time_of_day = '10:15-11:00', day = 'tirsdag'", :time_id => 3
    Period.update_all "time_of_day = '11:15-12:00', day = 'tirsdag'", :time_id => 4
    Period.update_all "time_of_day = '13:15-14:00', day = 'tirsdag'", :time_id => 5
  end

  def self.down
  end
end
