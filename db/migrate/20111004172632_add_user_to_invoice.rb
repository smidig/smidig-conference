# -*- encoding : utf-8 -*-
class AddUserToInvoice < ActiveRecord::Migration
  def self.up
   add_column :users, :invoice_id, :integer 
  end

  def self.down
    remove_column :users, :invoice_id
  end
end
