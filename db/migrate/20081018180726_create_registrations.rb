class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.integer :user_id
      t.text :comments
      t.decimal :price
      t.date :invoiced_at
      t.date :paid_at

      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
