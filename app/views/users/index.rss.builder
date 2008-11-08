atom_feed do |feed|
  feed.title("Users registered for Smidig 2009")
  feed.updated(@users.first.created_at)

  for user in @users
    feed.entry(user) do |entry|
      entry.title(user.name)
      entry.content(user.description, :type => 'html')

      entry.author do |author|
        author.name(user.name)
      end
    end
  end
end
