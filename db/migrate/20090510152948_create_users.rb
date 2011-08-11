# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :openid_identifier
      t.string :email,              :null => false
      t.string :crypted_password,   :null => false
      t.string :password_salt,      :null => false
      t.string :persistence_token,  :null => false

      t.string :name
      t.string :company
      t.string :phone_number
      t.text   :billing_address
      t.text   :description

      t.timestamps

      # Authlogic magic
      t.integer   :login_count,         :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
    end
    add_index :users, :openid_identifier, :unique => true
    add_index :users, :email, :unique => true
  end
  
  def self.down
    drop_table :users
  end
end
