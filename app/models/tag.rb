# -*- encoding : utf-8 -*-
class Tag < ActiveRecord::Base
  has_and_belongs_to_many :talks
  validates_presence_of :title
  validates_uniqueness_of :title, :case_sensitive => false

  def self.create_and_return_tags(tagnames) 
    tags = []
    tagnames.each { |title|
      tag = Tag.find(:first, :conditions => "LOWER(title) like '#{title.downcase}'")
	if(tag == nil) 
          tag = Tag.new({:title => title})
          tag.save!
        end
        tags.push(tag)
    }
    return tags
  end

end
