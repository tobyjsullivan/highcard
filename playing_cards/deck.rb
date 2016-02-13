require_relative 'card.rb'

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
