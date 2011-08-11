# -*- encoding : utf-8 -*-
class AddRegisteredByToPaymentNotification < ActiveRecord::Migration
  def self.up
    add_column :payment_notifications, :registered_by, :string
  end

  def self.down
    remove_column :payment_notifications, :registered_by
  end
end
