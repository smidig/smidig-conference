# -*- encoding : utf-8 -*-
class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :company_name
      t.string :contact_email
      t.string :contact_person
      t.string :street_address
      t.integer :post_code

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
