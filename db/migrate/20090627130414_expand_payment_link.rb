class ExpandPaymentLink < ActiveRecord::Migration
  def self.up
    change_column :registrations, :payment_link, :string, :length => 2000
  end

  def self.down
    change_column :registrations, :payment_link, :string, :length => 255
  end
end
