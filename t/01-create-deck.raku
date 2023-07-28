#!/usr/bin/env raku

use Triple::Triad;

# Define some cards
my $card1 = Card.new(name => "Card 1", rarity => Common, face-values => { top => 3, bottom => 5, left => 7, right => 2 });
my $card2 = Card.new(name => "Card 2", rarity => Common, face-values => { top => 2, bottom => 6, left => 8, right => 1 });
my $card3 = Card.new(name => "Card 3", rarity => Rare, face-values => { top => 1, bottom => 7, left => 6, right => 3 }, faction => Primal);
my $card4 = Card.new(name => "Card 4", rarity => Epic, face-values => { top => 5, bottom => 2, left => 4, right => 6 });
my $card5 = Card.new(name => "Card 5", rarity => Legendary, face-values => { top => 7, bottom => 8, left => 3, right => 4 });

# Create a deck
my $deck = Deck.new(player => Red, cards => [$card1, $card2, $card3, $card4, $card5]);

# Play a card
$deck.play-card($card1);

# Check the status of the card
say $card1.played;  # Should print True
