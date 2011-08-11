# -*- encoding : utf-8 -*-
class AddRegistrationIpToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :registration_ip, :string
  end

  def self.down
    remove_column :users, :registration_ip
  end

end
