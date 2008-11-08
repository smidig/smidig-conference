class Content < ActiveRecord::Base
  has_one :current_revision, :class_name => "ContentRevision", :order => "created_at desc"
  has_many :content_revisions
  #belongs_to :author, :class_name => "User"

  validates_presence_of :author, :title, :body
  attr_accessor :author, :title, :body
  
  def author
    @author ||= (current_revision && current_revision.author)
  end

  def title
    @title ||= (current_revision && current_revision.title)
  end

  def body
    @body ||= (current_revision && current_revision.body)
  end

  def last_edited_at
    current_revision && current_revision.created_at
  end

  def after_save
    content_revisions.create!(:title => title, :body => body, :author_id => author.id)
  end
  
  def owner
    author
  end
end
