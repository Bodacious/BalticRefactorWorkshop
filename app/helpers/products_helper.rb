module ProductsHelper
  STAR_EMOJI = -"&#11088; &#65039;"
  def stars_for_score(score)
    score.to_f.round.times.map { STAR_EMOJI  }.join.html_safe
  end
end
