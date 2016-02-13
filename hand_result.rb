# The HandResult class represents the resulting draws and scores of a single
# hand.
class HandResult
  attr_reader :score, :card1, :card2

  def initialize(player1_card: nil, player2_card: nil)
    raise 'player1_card must be a card.' unless player1_card.is_a?(Card)
    raise 'player2_card must be a card.' unless player2_card.is_a?(Card)

    @card1 = player1_card
    @card2 = player2_card
  end

  def score
    @score ||= {
      player1: player1_win? ? 1 : 0,
      player2: player2_win? ? 1 : 0
    }
  end

  def tie?
    @card1.value == @card2.value
  end

  def player1_win?
    @card1.value > @card2.value
  end

  def player2_win?
    @card2.value > @card1.value
  end
end
