%  Figure 24.10: Predicate library for king and rook vs king.


%  Position is represented by: Side..Wx:Wy..Rx:Ry..Bx:By..Depth
%  Side is side to move ('w' or 'b')
%  Wx, Wy are X and Y-coordinates of White king
%  Rx, Ry are X and Y-coordinates of White rook
%  Bx, By are coordinates of Black king
%  Depth is depth of position in search tree

% Selector relations

side( Side.._, Side).
wk( _..WK.._, WK).
wr( _.._..WR.._, WR).
bk( _.._.._..BK.._, BK).
depth( _.._.._.._..Depth, Depth).


resetdepth( S..W..R..B..D, S..W..R..B..0).   % Copy of position with depth 0


% Some relations between squares

n( N, N1)  :-       % Neighbour integers 'within board'
  ( N1 is N+1;
    N1 is N-1),
  in( N1).

in( N)  :-
  N > 0, N < 9.

diagngb( X:Y, X1:Y1)  :-      % Diagonal neighbour squares
  n( X, X1), n( Y, Y1).

verngb( X:Y, X:Y1)  :-        % Vertical neighbour squares
  n( Y, Y1).

horngb( X:Y, X1:Y)  :-        % Horizontal neighbour squares
  n( X, X1).

ngb( S, S1)  :-               % Neighbour squares, first diagonal
  diagngb( S, S1);
  horngb( S, S1);
  verngb( S, S1).


end_of_game( Pos)  :-
  mate( Pos).


%  Move constraints predicates
%  These are specialised move-generators:
%
%    move( MoveConstr, Pos, Move, NewPos)


move( depth < Max, Pos, Move, Pos1)  :-
  depth( Pos, D),
  D < Max, !.

move( depth = D, Pos, Move, Pos1)  :-
  depth( Pos, D), !.

move( kingdiagfirst, w..W..R..B..D, W-W1, b..W1..R..B..D1)  :-
  D1 is D+1,
  ngb( W, W1),         % 'ngb' generates diagonal moves first
  \+ ngb( W1, B),     % Must not move into check
  W1 \== R.            % Must not collide with rook

move( rookmove, w..W..Rx:Ry..B..D, Rx:Ry-R, b..W..R..B..D1)  :-
  D1 is D+1,
  coord( I),                % Integer between 1 and 8
  ( R = Rx:I; R = I:Ry),    % Move vertically or horizonatlly
  R \== Rx:Ry,              % Must have moved
  \+ inway( Rx:Ry, W, R).  % White king not in way

move( checkmove, Pos, R-Rx:Ry, Pos1)  :-
  wr( Pos, R),
  bk( Pos, Bx:By),
  (Rx = Bx; Ry = By),       % Rook and black king in line
  move( rookmove, Pos, R-Rx:Ry, Pos1).

move( legal, w..P, M, P1)  :-
  ( MC = kingdiagfirst; MC = rookmove; MC = checkfirst),
  move( MC, w..P, M, P1).

move( legal, b..W..R..B..D, B-B1, w..W..R..B1..D1)  :-
  D1 is D+1,
  ngb( B, B1),
  \+ check( w..W..R..B1..D1).

legalmove( Pos, Move, Pos1)  :-
  move( legal, Pos, Move, Pos1).

check( _..W..Rx:Ry..Bx:By.._)  :-
  ngb( W, Bx:By);          % King's too close
  ( Rx = Bx; Ry = By),
  Rx:Ry \== Bx:By,         % Not rook captured
  \+ inway( Rx:Ry, W, Bx:By).

inway( S, S1, S1)  :-  !.

inway( X1:Y, X2:Y, X3:Y)  :-
  ordered( X1, X2, X3), !.

inway( X:Y1, X:Y2, X:Y3)  :-
  ordered( Y1, Y2, Y3).

ordered( N1, N2, N3)  :-
  N1 < N2, N2 < N3;
  N3 < N2, N2 < N1.

coord(1).  coord(2).  coord(3).  coord(4).
coord(5).  coord(6).  coord(7).  coord(8).


%  Goal predicates

true( Pos).

themtomove( b.._).        % Black = 'them' to move

mate( Pos)  :-
  side( Pos, b),
  check( Pos),
  \+ legalmove( Pos, _, _).

stalemate( Pos)  :-
  side( Pos, b),
  \+ check( Pos),
  \+ legalmove( Pos, _, _).

newroomsmaller( Pos, RootPos)  :-
  room( Pos, Room),
  room( RootPos, RootRoom),
  Room < RootRoom.

rookexposed( Side..W..R..B.._)  :-
  dist( W, R, D1),
  dist( B, R, D2),
  ( Side = w, !, D1 > D2+1;
    Side = b, !, D1 > D2 ).

okapproachedcsquare( Pos, RootPos)  :-
  okcsquaremdist( Pos, D1),
  okcsquaremdist( RootPos, D2),
  D1 < D2.


okcsquaremdist( Pos, Mdist)  :-  % Manh. dist. between WK and critical square
  wk( Pos, WK),
  cs( Pos, CS),                   % Critical square
  manhdist( WK, CS, Mdist).

rookdivides( _..Wx:Wy..Rx:Ry..Bx:By.._)  :-
  ordered( Wx, Rx, Bx), !;
  ordered( Wy, Ry, By).

lpatt( _..W..R..B.._)  :-      % L-pattern
  manhdist( W, B, 2),
  manhdist( R, B, 3).

okorndle( _..W..R.._, _..W1..R1.._)  :-
  dist( W, R, D),
  dist( W1, R1, D1),
  D =< D1.

roomgt2( Pos)  :-
  room( Pos, Room),
  Room > 2.

our_king_edge( _..X:Y.._)  :-        % White king on edge
  ( X=1, !; X=8, !; Y=1, !; Y=8).

their_king_edge( _..W..R..X:Y.._)  :-   % Black king on edge
  ( X=1, !; X=8, !; Y=1, !; Y=8).

kings_close( Pos)  :-                 % Dist. between kings < 4
  wk( Pos, WK), bk( Pos, BK),
  dist( WK, BK, D),
  D < 4.

rooklost( _..W..B..B.._).     % Rook has been captured

rooklost( b..W..R..B.._)  :-
  ngb( B, R),                 % B. king attacks rook
  \+ ngb( W, R).             % W. king does not defend


dist( X:Y, X1:Y1, D)  :-           % Distance in king moves
  absdiff( X, X1, Dx),
  absdiff( Y, Y1, Dy),
  max( Dx, Dy, D).

absdiff( A, B, D)  :-
  A > B, !, D is A-B;
  D is B-A.

max( A, B, M)  :-
  A >= B, !, M = A;
  M = B.

manhdist( X:Y, X1:Y1, D)  :-      % Manhattan distance
  absdiff( X, X1, Dx),
  absdiff( Y, Y1, Dy),
  D is Dx + Dy.

room( Pos, Room)  :-	        % Area to which B. king is confined
  wr( Pos, Rx:Ry),
  bk( Pos, Bx:By),
  ( Bx < Rx, SideX is Rx - 1; Bx > Rx, SideX is 8 - Rx),
  ( By < Ry, SideY is Ry - 1; By > Ry, SideY is 8 - Ry),
  Room is SideX * SideY, !;
  Room is 64.                   % Rook in line with Black king

cs( _..W..Rx:Ry..Bx:By.._, Cx:Cy)  :-      % 'Critical square'
  ( Bx < Rx, !, Cx is Rx-1; Cx is Rx+1),
  ( By < Ry, !, Cy is Ry-1; Cy is Ry+1).


% Display procedures

show( Pos)  :-
  nl,
  coord( Y), nl,
  coord( X),
  writepiece( X:Y, Pos),
  fail.

show( Pos)  :-
  side( Pos, S), depth( Pos, D),
  nl, write('Side='), write(S),
  write(' Depth='), write(D), nl.

writepiece( Square, Pos)  :-
  wk( Pos, Square), !, write('W');
  wr( Pos, Square), !, write('R');
  bk( Pos, Square), !, write('B');
  write('.').

showmove( Move)  :-
  nl, write(Move), nl.

