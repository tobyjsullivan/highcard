require_relative 'playing_cards/deck.rb'
require_relative 'hand_result.rb'

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
