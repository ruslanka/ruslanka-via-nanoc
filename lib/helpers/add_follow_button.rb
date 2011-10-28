module AddFollowButton
  def add_follow_button(service, title)
    url = @site.config[:base_url] + item.path
		%Q!<a href="http://share.yandex.ru/go.xml?service=#{service}&amp;url=#{ h url }&amp;title=#{ h item[:title] }" class="icon icon_#{service}" title="#{title}" target="_blank"></a>!
  end
end

include AddFollowButton

