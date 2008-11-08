class CreateContentRevisions < ActiveRecord::Migration
  def self.up
    create_table :content_revisions do |t|
      t.string :title
      t.text :body
      t.integer :content_id
      t.integer :author_id
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :content_revisions
  end
end
