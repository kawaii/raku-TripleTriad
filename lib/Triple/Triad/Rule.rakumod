unit module Triple::Triad::Rule;

class Rule is export {
    method run(Board $board) { ... }
}

class StandardPowerRule is Rule is export {
    method run(Board $board, Int $x, Int $y) {
        my $placed-card = $board.board[$x;$y];
        
        # Top adjacent
        if $x > 0 && $board.board[$x - 1;$y].defined && $board.board[$x - 1;$y].owner != $placed-card.owner {
            if $placed-card.face-values<top> > $board.board[$x - 1;$y].face-values<bottom> {
                $board.flip-card($x - 1, $y, $placed-card.owner);
            }
        }

        # Bottom adjacent
        if $x < 2 && $board.board[$x + 1;$y].defined && $board.board[$x + 1;$y].owner != $placed-card.owner {
            if $placed-card.face-values<bottom> > $board.board[$x + 1;$y].face-values<top> {
                $board.flip_card($x + 1, $y, $placed-card.owner);
            }
        }

        # Left adjacent
        if $y > 0 && $board.board[$x;$y - 1].defined && $board.board[$x;$y - 1].owner != $placed-card.owner {
            if $placed-card.face-values<left> > $board.board[$x;$y - 1].face-values<right> {
                $board.flip_card($x, $y - 1, $placed-card.owner);
            }
        }

        # Right adjacent
        if $y < 2 && $board.board[$x;$y + 1].defined && $board.board[$x;$y + 1].owner != $placed-card.owner {
            if $placed-card.face-values<right> > $board.board[$x;$y + 1].face-values<left> {
                $board.flip_card($x, $y + 1, $placed-card.owner);
            }
        }
    }
}

