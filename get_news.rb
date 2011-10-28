#!/usr/bin/ruby

require 'rubygems'
require 'rutils'
require 'extlib'
require 'rss'
require 'open-uri'
require 'fileutils'

def write_item(path, meta, contents)
FileUtils.mkpath( File.split(path).first )
  open(path,'w+') do |f|
	  f.print "--"
	  f.puts meta.to_yaml
	  f.puts "-----"
	  f.puts contents
  end
end
=begin
#rss = RSS::Parser.parse( open('http://ruslanam.ya.ru/rss/posts.xml') )

RSS::Parser.parse( open('http://rubycat.ru/feed') )
rss.channel.items.each{ |item|
  meta = {}
  meta[:title] = item.title
  meta[:source] = item.link
  meta[:created_at] = item.pubDate
  meta[:author] = item.dc_creator || rss.channel.title
  meta[:description] = item.description
  meta[:tags] = item.category.content

  write_item( Dir.pwd / "content" / "news" / item.title.dirify + '.html', meta, item.content_encoded || item.description )
}
=end
require 'open-uri'
require 'base64'
require 'net/http'
require 'rss'

#puts open('http://memori.ru/api-v2/posts/all', "Autorization" => "Basic " + Base64.encode64("rubynovich:ykp9vc5qa").chomp ){ |io| io.read }




feed = 'http://delicious.com/v2/rss/rubynovich/ruslanka.ru?private=eRVw7-cXcW2AXpVQNakkwIR6AB-ad6vEr3VR2YEw8g0='
rss = RSS::Parser.parse( open(feed) )
rss.channel.items.each{ |item|
  meta = {}
puts meta[:title] = item.title || item.link.split("?").last
  meta[:source] = item.link
  meta[:created_at] = item.pubDate
  meta[:author] = item.dc_creator || rss.channel.title
  meta[:description] = item.description.strip
#  meta[:tags] = item.category.content if item.category
  meta[:screenshot] = "http://queue.s-shot.ru/1024x768/200/png/?%s" % item.link

  write_item( Dir.pwd/"content/links"/meta[:title] + '.html', meta, %Q|<%= render 'links' %>|)
}

