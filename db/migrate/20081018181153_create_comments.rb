# -*- encoding : utf-8 -*-
class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :talk_id
      t.integer :user_id
      t.string :title
      t.text :description
      t.boolean :is_displayed
      t.boolean :is_a_review

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
