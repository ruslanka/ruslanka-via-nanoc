module HistoryList
  def history_list(items)
    timeline = ["Античность","Средние века", "Возрождение", "Новое время","Новейшее время"]
    items.select{ |item| item[:age] }.inject( {} ){ |result,item|
      result.update( { item[:age] => [item] } ){ |k,o,n| o + n }
    }.sort_by{ |age, items| timeline.index(age) }.map{ |age, items|
      %Q'h2. #{ age }\n\n' +
        items.map{ |item|
          %Q'* "#{ item[:title] }":#{ item.path }'
        }.join("\n")
    }.join("\n\n")
  end
end

include HistoryList

