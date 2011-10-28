module TicketsList
  def tickets_list(items)
    items.select{ |itm| itm[:university] }.inject( {} ){ |result,itm|
      result.update( { itm[:year] => [itm] } ){ |k,o,n| o + n }
    }.sort_by{ |year,itms| year }.map{ |year, itms|
      %Q'h3. #{ year }\n\n%s' %
        itms.inject( {} ){ |res,itm|
          res.update( itm[:discipline] => [itm] ){ |k,o,n| o + n }
        }.sort_by{ |disc,its| disc }.map{ |disc, its|
          %Q'* #{ disc } (%s)' %
            its.map{ |it| %Q'"%s":%s' % [it[:title], it.path ] }.join(", ")
        }.join("\n")
    }.join("\n\n")
  end
end

include TicketsList

