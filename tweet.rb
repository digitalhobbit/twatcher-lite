class Tweet
  
  def initialize(data)
    @data = data
  end

  def user_link
    "http://twitter.com/#{username}"
  end

  # Makes links clickable, highlights LOL, etc.
  def filtered_text
    filter_lol(filter_urls(text))
  end

  private
  
  # So we can call tweet.text instead of tweet['text']
  def method_missing(name)
    @data[name.to_s]
  end
  
  def filter_lol(text)
    # Note that we're using a list of characters rather than just \b to avoid
    # replacing LOL inside a URL.
    text.gsub(/^(.*[\s\.\,\;])?(lol)(\b)/i, '\1<span class="lol">\2</span>\3')
  end
  
  def filter_urls(text)
    # The regex could probably still be improved, but this seems to do the
    # trick for most cases.
    text.gsub(/(https?:\/\/\w+(\.\w+)+(\/[\w\+\-\,\%]+)*(\?[\w\[\]]+(=\w*)?(&\w+(=\w*)?)*)?(#\w+)?)/i, '<a href="\1">\1</a>')
  end
  
end