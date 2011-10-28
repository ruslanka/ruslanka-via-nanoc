require 'rubygems'
require 'extlib'
require 'pathname'
require 'fileutils'
require 'nanoc3'
require "#{Dir.pwd}/lib/utils.rb"
require 'rutils'
require 'rss'
require 'open-uri'

include SiteUtils

namespace :site do
# rake site:news feed="http://rubycat.ru/feed"
# rake site:news feed="http://ruslanam.ya.ru/rss/posts.xml?posttype=complaint,description,news,offline,premoderated,rules,summon,text"
  task :news, :feed do |t, args|
    raise RuntimeError, "Имя потока не задано" unless args[:feed]
    rss = RSS::Parser.parse( open(args[:feed]) )
    rss.channel.items.each{ |item|
      meta = {}
      meta[:title] = item.title || item.link.split("?").last
      meta[:source] = item.link
      meta[:source_host] = URI.parse( item.link ).host
      meta[:created_at] = item.pubDate
      meta[:author] = item.dc_creator || rss.channel.title
      meta[:description] = item.description
      meta[:tags] = item.category.content

      write_item( Dir.pwd/"content/notes"/meta[:source_host]/meta[:title].dirify + '.html', meta, item.content_encoded || item.description )
    }
  end

	task :clean do
		output = Pathname.new(Dir.pwd)/'output'
		puts "Удаление всех файлов в директории output..."
		output.rmtree
#		(output/'data').mkpath
	end

#	task :update => [:tags, :archives, :compile] do
  task :update => [:compile] do
	end

	task :compile do
		system "nanoc3 co"
	end

	task :run do
		system "nanoc3 aco -s thin"
	end

	task :rebuild => [:clean, :update] do
	end
=begin
	task :tags do
		site = Nanoc3::Site.new('.')
		site.load_data
		dir = Pathname(Dir.pwd)/'content/tags'
		tags = {}
		# Collect tag and page data
		site.items.each do |p|
			next unless p.attributes[:tags]
			p.attributes[:tags].each do |t|
				if tags[t]
					tags[t] = tags[t]+1
				else
					tags[t] = 1
				end
			end
		end
		# Write pages
		tags.each_pair do |k, v|
			unless (dir/"#{k}.textile").exist? && (dir/"#{k}-rss.xml").exist? && (dir/"#{k}-atom.xml").exist? then
				puts "Создание страницы для тега '#{k}'"
				write_tag_page dir, k, v
				write_tag_feed_page dir, k, 'RSS'
				write_tag_feed_page dir, k, 'Atom'
			end
		end
		# Remove unused tags
		dir.children.each do |c|
			t = c.basename.to_s.gsub /(-(rss|atom))?\..+$/, ''
			unless tags[t] then
				puts "Удаление страницы тега, который уже не используется '#{c.basename}'"
				c.delete
			end
		end
	end

	task :archives do
		site = Nanoc3::Site.new('.')
		site.load_data
		dir = Pathname(Dir.pwd)/'content/archives'
		dir.rmtree if dir.exist?
		dir.mkpath
		m_articles = []
		index = -1
		current_month = ""
		# Collect month and page data
		articles = site.items.select{|p| p.attributes[:date] && p.attributes[:type] == 'article'}.sort{|a, b| a.attributes[:date] <=> b.attributes[:date]}.reverse
		articles.each do |a|
			month = a.attributes[:date].strftime("%B %Y")
			if current_month != month then
				# new month
				m_articles << [month, [a]]
				index = index + 1
				current_month = month
			else
				# same month
				m_articles[index][1] << a
			end
		end
		# Write pages
		m_articles.each do |m|
			write_archive_page dir, m[0], m[1].length
		end
	end
=end
	task :article, :name do |t, args|
		raise RuntimeError, "Имя статьи не задано" unless args[:name]
		raise RuntimeError, "Имя статьи может состоять только из латиницы, цифр и дефиса" unless args[:name].match /^[a-zA-Z0-9-]+$/
		meta = {}
		meta[:permalink] = args[:name]
		meta[:title] = nil
		meta[:subtitle] = nil
		meta[:type] = 'article'
		meta[:intro] = nil
		meta[:extended_intro] = nil
		meta[:tags] = nil
		meta[:date] = Time.now
		meta[:toc] = true
		meta[:pdf] = true
		file = Pathname.new Dir.pwd/"content/articles/#{meta[:permalink]}.glyph"
		raise "Файл '#{file}' уже используется!" if file.exist?
		write_item file, meta, ''
	end

	task :page, :name do |t, args|
		raise RuntimeError, "Имя статьи не задано" unless args[:name]
		raise RuntimeError, "Имя страницы может состоять только из латиницы, цифр и дефиса" unless args[:name].match /^[a-zA-Z0-9-]+$/
		meta = {}
		meta[:permalink] = args[:name]
		meta[:title] = ""
		meta[:type] = 'page'
		file = Pathname.new Dir.pwd/"content/#{meta[:permalink]}.textile"
		raise "Файл '#{file}' уже используется!" if file.exist?
		write_item file, meta, ''
	end

	task :project, :name do |t, args|
		raise RuntimeError, "Имя статьи не задано" unless args[:name]
		raise RuntimeError, "Имя проекта может состоять только из латиницы, цифр и дефиса" unless args[:name].match /^[a-zA-Z0-9-]+$/
		meta = {}
		meta[:permalink] = args[:name]
		meta[:title] = ""
		meta[:github] = args[:name]
		meta[:status] = "Active"
		meta[:version] = "0.1.0"
		meta[:type] = 'project'
		meta[:links] = [{"Документация" => "http://rubydoc.info/gems/#{args[:name]}/#{meta[:version]}/frames"},
										{"Скачать" => "https://rubygems.org/gems/#{args[:name]}"},
										{"Исходный код" => "http://github.com/h3rald/#{args[:name]}/tree/master"},
										{"Трекер" => "http://github.com/h3rald/#{args[:name]}/issues"}]
		contents = %{
<%= render 'project_data', :tag => '#{args[:name]}' %>

h3. Установка

h3. Использование

<%= render 'project_updates', :tag => '#{args[:name]}' %>
		}
		file = Pathname.new Dir.pwd/"content/#{meta[:permalink]}.textile"
		raise "Файл '#{file}' уже используется!" if file.exist?
		write_item file, meta, contents
	end

end

