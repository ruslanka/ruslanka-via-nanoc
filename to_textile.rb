#!/usr/bin/ruby

require 'htmltotextile'
require 'open-uri'



class String
  def to_textile
    HTML2Textile.new(self).to_textile
  end
end

puts open('content/news/rubycat.ru/formatirovanie-stroki-v-ruby.html'){ |io| io.read }.to_textile

