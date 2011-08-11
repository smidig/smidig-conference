# -*- encoding : utf-8 -*-
class AddLicenseToTalks < ActiveRecord::Migration
  def self.up
    add_column :talks, :allow_commercial_use, :boolean
    add_column :talks, :allow_derivatives, :string
  end

  def self.down
    remove_column :talks, :allow_derivatives
    remove_column :talks, :allow_commercial_use
  end
end
