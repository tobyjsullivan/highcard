# A game of High Card.
class HighcardGame
  attr_reader :score, :player1_name, :player2_name

  def initialize(player1_name: 'Player 1', player2_name: 'Player 2')
    @player1_name = player1_name
    @player2_name = player2_name

    @deck = Deck.new
    @score = {
      player1: 0,
      player2: 0
    }
  end

  def play_hand
    card1 = @deck.draw_without_replacement
    card2 = @deck.draw_without_replacement

    result = HandResult.new(player1_card: card1, player2_card: card2)
    update_scores(result)

    result
  end

  def game_over?
    @deck.cards_remaining < 2
  end

  private

  def update_scores(hand_result)
    raise 'hand_result must be a HandResult instance.' unless
      hand_result.is_a?(HandResult)

    @score[:player1] += hand_result.score[:player1]
    @score[:player2] += hand_result.score[:player2]
  end
end

# A Deck represents a collection of cards which are used in a game.
class Deck
  def initialize
    @cards = fill_deck.shuffle
  end

  def draw_without_replacement
    card, *remaining = @cards
    @cards = remaining
    card
  end

  def cards_remaining
    @cards.count
  end

  private

  def fill_deck
    cards = Card.all_suits.collect do |suit|
      suit_cards = (1..13).collect do |value|
        Card.new(value, suit)
      end
      suit_cards
    end

    cards.flatten
  end
end

# Represents a simple playing card. Has a suit and a value (e.g., A three of
# clubs).
class Card
  attr_reader :value, :suit

  def initialize(value, suit)
    raise 'value is not valid.' unless Card.valid_value? value
    raise 'suit is not valid.' unless Card.valid_suit? suit

    @value = value
    @suit = suit
  end

  def to_s
    format('%d of %s', @value, @suit)
  end

  def self.all_suits
    [:hearts, :diamonds, :spades, :clubs]
  end

  def self.valid_value?(value)
    value.is_a?(Integer) && value >= 1 && value <= 13
  end

  def self.valid_suit?(suit)
    all_suits.include?(suit)
  end
end

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

puts 'Game begins'
game = HighcardGame.new(player1_name: 'Toby', player2_name: 'Computer')
until game.game_over?
  puts format('Score: %d - %d', game.score[:player1], game.score[:player2])
  puts 'Press [ENTER] to play next hand.'
  gets
  result = game.play_hand
  puts format('Drew %s for %s and %s for %s', result.card1,
              game.player1_name, result.card2, game.player2_name)
  if result.tie?
    puts 'The hand is a tie.'
  elsif result.player1_win?
    puts format('%s wins the hand!', game.player1_name.capitalize)
  elsif result.player2_win?
    puts format('%s wins the hand!', game.player2_name.capitalize)
  else
    raise 'No tie and no winner. Something is wrong.'
  end
end
puts 'The game is over, folks!'
puts format('Final score: %d - %d', game.score[:player1], game.score[:player2])
if game.score[:player1] > game.score[:player2]
  puts format('%s wins the game!', game.player1_name)
elsif game.score[:player2] > game.score[:player1]
  puts format('%s wins the game!', game.player2_name)
else
  puts 'The game was a tie.'
end
