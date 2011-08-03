atom_feed do |feed|
  feed.title("Smidig 2011 lyntaler")
  feed.updated(@talks.first.created_at)

  for talk in @talks
    feed.entry(talk) do |entry|
      entry.title(talk.title)
      entry.content(simple_format(talk.description), :type => 'html')

      entry.author do |author|
        author.name(talk.speaker_name)
      end
    end
  end
end
