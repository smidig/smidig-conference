class CreateTalkTypes < ActiveRecord::Migration
  def self.up
    create_table :talk_types do |t|
      t.string :name
      t.string :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :talk_types
  end
end
