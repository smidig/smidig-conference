# -*- encoding : utf-8 -*-
class AddCommentsTable < ActiveRecord::Migration
  def self.up
    create_table :feedback_comments do |t|
      t.column :talk_id, :integer
      t.column :comment, :string
    end
  end

  def self.down
    drop_table :feedback_comments
  end
end
