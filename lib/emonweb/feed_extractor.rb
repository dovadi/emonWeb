class FeedExtractor

  def initialize(feeds, names)
    @feeds = feeds
    @names = names
  end

  #TO DO: Now assumes only one feed per input.
  def values
    result = {}
    @feeds.each do |feed|
      input = feed.input
      @names.each do |name|
        result[name] = DataStore.from(feed.id).last.value if input && input.name == name.to_s
      end
    end
    result
  end
end