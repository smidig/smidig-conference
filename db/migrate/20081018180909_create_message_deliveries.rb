class CreateMessageDeliveries < ActiveRecord::Migration
  def self.up
    create_table :message_deliveries do |t|
      t.integer :message_id
      t.integer :registration_id
      t.datetime :sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :message_deliveries
  end
end
