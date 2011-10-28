module TranslateWord
  def to_ru(word)
    {"history" => "История"}[word]
  end
end

include TranslateWord

