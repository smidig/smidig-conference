# -*- encoding : utf-8 -*-
class AddDinnerAndEarlyBirdToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :is_earlybird, :boolean
    add_column :registrations, :includes_dinner, :boolean
    add_column :registrations, :description, :string
  end

  def self.down
    remove_column :registrations, :is_earlybird
    remove_column :registrations, :includes_dinner
    remove_column :registrations, :description
  end
end
