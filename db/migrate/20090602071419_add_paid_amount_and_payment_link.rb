class AddPaidAmountAndPaymentLink < ActiveRecord::Migration
    def self.up
      add_column :registrations, :payment_link, :string
      add_column :payment_notifications, :paid_amount, :decimal
      add_column :payment_notifications, :currency, :string
    end

    def self.down
      remove_column :registrations, :payment_link
      remove_column :payment_notifications, :paid_amount
      remove_column :payment_notifications, :currency
    end
  end
