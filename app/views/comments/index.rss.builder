atom_feed do |feed|
  feed.title("Comments for Smidig 2011 talks")
  feed.updated(@comments.first.created_at) unless @comments.empty?

  for comment in @comments
    link = url_for(:controller => 'talks', :action => 'show', :id => comment.talk, :anchor => dom_id(comment), :only_path => false)
    feed.entry(comment, :url => link) do |entry|
      entry.title(comment.title)
      entry.content(comment.description, :type => 'html')

      entry.author do |author|
        author.name(comment.user_name)
      end
    end
  end
end
