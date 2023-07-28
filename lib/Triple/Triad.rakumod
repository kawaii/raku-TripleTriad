unit class Triple::Triad;

enum Player <Red Blue>;

# You can have as many rare or lower cards per deck as you like, but you may only have up to two epic or legendary cards, with only one legendary allowed per deck.
enum Rarity <Common Uncommon Rare Epic Legendary>;
# Certain cards have an icon on the upper right corner that represents a specific faction – "Primal", "Beastmen", "Scion", or "Garlean". These faction cards come into play during specific rules.
enum Faction <Primal Beastmen Scion Garlean>;

class Card {
    has Str $.name;
    has Rarity $.rarity;
    has Hash $.face-values is rw;
    has Faction $.faction is rw = Nil;

    has Bool $.played = False;  # new attribute to track if the card has been played

    # In the constructor, initialize face-values as an empty Hash and faction as an optional parameter.
    submethod BUILD (
        :$!name!,
        Rarity :$!rarity!,
        :$!face-values is copy = {},
        Faction :$!faction
    ) {
        die "Face values for top, bottom, left and right must be provided"
            unless $!face-values.keys.sort.join(' ') eq 'bottom left right top';

        for $!face-values.kv -> $direction, $value {
            die "Face value for $direction must be an integer" unless $value ~~ Int;
            die "Face value for $direction must range from 1 to 10" unless $value ~~ 1..10;
        }
    }
}

class Deck {
    has Player $.player;
    has Card @.cards;

    submethod BUILD (Player :$!player!, :@!cards!) {
        die "A deck must contain exactly 5 cards" unless @!cards.elems == 5;

        my $epic-legendary = @!cards.grep({ $_.rarity ~~ Epic|Legendary });
        my $legendary = @!cards.grep({ $_.rarity ~~ Legendary });

        die "A deck can contain at most 2 Epic or Legendary cards" if $epic-legendary > 2;
        die "A deck can contain only 1 Legendary card" if $legendary > 1;
    }

    method play-card(Card $card) {
        die "Card has already been played" if $card.played;
        $card.played = True;
    }
}

