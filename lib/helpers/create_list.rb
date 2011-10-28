module CreateList
  def create_list(name,items,criterions)
    criterion = criterions.pop
    "<li><a href=\"#\">#{ name }</a><ul>%s</ul></li>" % case criterions.size
    when 1
      items.select{ |itm| criterion[itm] }.map{ |itm|
        "<li><a href=\"%s\">%s</a></li>" % [itm.path, itm[:title]]
      }.join
    else
      "<li><a href=\"#\">#{name}</a><ul>%s</ul></li>" % create_list(criterion,items,criterions)
    end
  end
end

# include CreateList

