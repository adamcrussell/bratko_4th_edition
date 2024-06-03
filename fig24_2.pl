%  A game tree (Figure 24.2 translated to Prolog)

%  moves( Position, PositionList): possible moves

moves( a, [b,c]).
moves( b, [d,e]).
moves( c, [f,g]).
moves( d, [i,j]).
moves( e, [k,l]).
moves( f, [m,n]).
moves( g, [o,p]).

% min_to_move( Pos): Player 'min' to move in Pos

min_to_move( b).
min_to_move( c).

% max_to_move Pos): Player 'max' to move in Pos

max_to_move( a).
max_to_move( d).
max_to_move( e).
max_to_move( f).
max_to_move( g).

% staticval( Pos, Value):  Value is the static value of Pos

staticval( i, 1).
staticval( j, 4).
staticval( k, 5).
staticval( l, 6).
staticval( m, 2).
staticval( n, 1).
staticval( o, 1).
staticval( p, 1).
