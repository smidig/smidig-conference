class AddAcceptanceChangedAtToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :acceptance_changed_at, :datetime
  end

  def self.down
    remove_column :talks, :acceptance_changed_at
  end
end
