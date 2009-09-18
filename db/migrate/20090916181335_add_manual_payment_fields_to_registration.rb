class AddManualPaymentFieldsToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :ticket_type, :text
    add_column :registrations, :payment_notification_params, :text
    add_column :registrations, :payment_complete_at, :datetime
    add_column :registrations, :paid_amount, :decimal
    add_column :registrations, :payment_reference, :text
    add_column :registrations, :registration_complete, :boolean
    add_column :registrations, :manual_payment, :boolean
    add_column :registrations, :invoice_address, :text
    add_column :registrations, :invoice_description, :text
    add_column :registrations, :free_ticket, :boolean
    add_column :registrations, :completed_by, :string
    remove_column :users, :billing_address
  end

  def self.down
    add_column :users, :billing_address, :text
    remove_column :registrations, :completed_by, :string
    remove_column :registrations, :payment_notification_params, :text
    remove_column :registrations, :paid_amount, :text
    remove_column :registrations, :payment_reference, :text
    remove_column :registrations, :registration_complete, :boolean
    remove_column :registrations, :manual_payment, :boolean
    remove_column :registrations, :invoice_address, :text
    remove_column :registrations, :invoice_description, :text
    remove_column :registrations, :free_ticket, :boolean
    remove_column :registrations, :ticket_type, :text
  end
end
