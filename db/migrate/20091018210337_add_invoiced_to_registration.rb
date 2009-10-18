class AddInvoicedToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :invoiced, :boolean
  end

  def self.down
    remove_column :registrations, :invoiced
  end
end
