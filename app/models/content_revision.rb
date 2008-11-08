class ContentRevision < ActiveRecord::Base
  belongs_to :content
  belongs_to :author, :class_name => "User"
end
