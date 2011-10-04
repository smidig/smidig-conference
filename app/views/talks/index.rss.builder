atom_feed do |feed|
  feed.title("Smidig 2011 bidrag")
  feed.updated(@talks.first.created_at) unless @talks.empty?

  for talk in @talks
    feed.entry(talk) do |entry|
      entry.title(talk.title)
      entry.content(simple_format(talk.description_and_type), :type => 'html')

      entry.author do |author|
        author.name(talk.speaker_name)
      end
    end
  end
end
