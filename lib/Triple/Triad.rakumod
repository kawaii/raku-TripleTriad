unit module Triple::Triad;

use Triple::Triad::Rule;

enum Player is export <Red Blue>;

# You can have as many rare or lower cards per deck as you like, but you may only have up to two epic or legendary cards, with only one legendary allowed per deck.
enum Rarity is export <Common Uncommon Rare Epic Legendary>;
# Certain cards have an icon on the upper right corner that represents a specific faction – "Primal", "Beastmen", "Scion", or "Garlean". These faction cards come into play during specific rules.
enum Faction is export <Primal Beastmen Scion Garlean>;

class Card is export {
    has Str $.name;
    has Rarity $.rarity;
    has Hash $.face-values is rw;
    has Faction $.faction is rw = Nil;

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

class Deck is export {
    has Player $.player;
    has Card @.cards;

    submethod BUILD (Player :$!player!, :@!cards!) {
        die "A deck must contain exactly 5 cards" unless @!cards.elems == 5;

        my $epic-legendary = @!cards.grep({ $_.rarity ~~ Epic|Legendary });
        my $legendary = @!cards.grep({ $_.rarity ~~ Legendary });

        die "A deck can contain at most 2 Epic or Legendary cards" if $epic-legendary > 2;
        die "A deck can contain only 1 Legendary card" if $legendary > 1;
    }
}

class Player is export {
    has Str $.name;
    has Deck $.deck;

    submethod BUILD (: $!name!, Deck :$!deck!) { ... }
}

class Board is export {
    has Card @.board[3;3] is rw = Nil xx 9; # Initializes a 3x3 matrix with all `Nil` values
    has Player $.red-player;
    has Player $.blue-player;
    has Player %.ownership is rw;

    submethod BUILD (Player :$!red-player!, Player :$!blue-player!) { ... }

    method flip-card(Int $x, Int $y, Player $new-owner) {
        @.board[$x;$y].owner = $new-owner;
    }
}

class GameState is export {
    has Board $.board;
    has Rule @.rules;
    has Player $.current-player is rw;

    submethod BUILD (Board :$!board!, :@!rules!, Player :$starting-player!) {
        $!current-player = $starting-player;
    }

    method play-card(Player $player, Card $card, Int $x, Int $y) {
        die "It is not $player's turn" unless $player eqv $.current-player;
        die "The specified board position is already occupied" if $.board.board[$x;$y].defined;
        die "$player does not have the specified card in their deck" unless $card (elem) $.current-player.deck.cards;

        # Place the card on the board
        $.board.place-card($player, $card, $x, $y);

        # Apply all active rules
        for @.rules -> $rule {
            $rule.run($.board, $x, $y);
        }

        # Switch to the other player for the next turn
        $.current-player = $.current-player === $.board.red-player ?? $.board.blue-player !! $.board.red-player;
    }
}
