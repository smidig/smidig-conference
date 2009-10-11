class AddTitleToPeriod < ActiveRecord::Migration
  def self.up
    add_column :periods, :title, :string
  end

  def self.down
    remove_column :periods, :title
  end
end
