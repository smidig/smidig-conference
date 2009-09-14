class DynamicPaymentUrl < ActiveRecord::Migration
  def self.up
    remove_column :registrations, :payment_link
  end

  def self.down
    add_column :registrations, :payment_link, :string
  end
end
