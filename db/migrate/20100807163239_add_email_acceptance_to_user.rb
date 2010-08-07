class AddEmailAcceptanceToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :accepted_privacy_guidelines, :boolean
    add_column :users, :accept_promotional_email, :boolean
  end

  def self.down
    remove_column :users, :accept_promotional_email
    remove_column :users, :accepted_privacy_guidelines
  end
end
