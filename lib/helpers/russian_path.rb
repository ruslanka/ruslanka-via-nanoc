module RussianPath
  def russian_path(item)
    case item.path.split("/")[1]
    when 'history'
      [ "История", item[:age], item[:title] ]
    when 'tickets'
      [ "Билеты", item[:university], item[:year], item[:discipline], item[:title] ]
    when 'notes'
      item[:created_at] ? ["Заметки", "#{item[:created_at].year} год", %w{Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Ноябрь Декабрь}[item[:created_at].month-1],item[:title]] : ["Заметки", item[:title]]
    else
      [ item[:title] ]
    end.compact.join(" &#8594; ")
  end
end

include RussianPath

