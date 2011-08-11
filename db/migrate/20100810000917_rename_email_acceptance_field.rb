# -*- encoding : utf-8 -*-
class RenameEmailAcceptanceField < ActiveRecord::Migration
  def self.up
    add_column :users, :accept_optional_email, :boolean
    remove_column :users, :accept_promotional_email
  end

  def self.down
    add_column :users, :accept_promotional_email, :boolean
    remove_column :users, :accept_optional_email, :boolean
  end
end
