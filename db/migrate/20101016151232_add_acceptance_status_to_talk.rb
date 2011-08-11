# -*- encoding : utf-8 -*-
class AddAcceptanceStatusToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :acceptance_status, :string
  end

  def self.down
    remove_column :talks, :acceptance_status
  end
end
