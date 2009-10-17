class AddTimeToPeriod < ActiveRecord::Migration
  def self.up
    add_column :periods, :time_of_day, :string
    add_column :periods, :day, :string
  end

  def self.down
    remove_column :periods, :day
    remove_column :periods, :time_of_day
  end
end
