class FeedExtractor

  def initialize(feeds, names)
    @feeds = feeds
    @names = names
  end

  def values
    result = {}
    @feeds.each do |feed|
      input = feed.input
      @names.each do |name|
        result[name] = input.last_value if input && input.name == name.to_s
      end
    end
    result
  end
end