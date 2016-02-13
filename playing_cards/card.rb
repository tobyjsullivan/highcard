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
