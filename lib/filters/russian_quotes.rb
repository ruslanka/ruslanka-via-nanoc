require 'rubygems'
require 'rutils'
require 'redcloth'

include RuTils

class RussianQuotesFilter < Nanoc3::Filter
  identifier :russian_quotes
  type :text

  def run(content, params={})
    Gilenson::RedClothExtra.new(content).to_html
  end
end

