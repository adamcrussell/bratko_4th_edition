% Figure 12.6  Problem-specific procedures for the eight 
% puzzle, to be used in best-first search of Figure 12.3.


/* Problem-specific procedures for the eight puzzle

Current situation is represented as a list of positions of the tiles, 
with first item in the list corresponding to the empty square.

Example:

                           This position is represented by:
3        1    2    3
2        8         4       [2/2, 1/3, 2/3, 3/3, 3/2, 3/1, 2/1, 1/1, 1/2]
1        7    6    5
          
         1    2    3

"Empty' can move to any of its neighbours which means 
that "empty' and its neighbour interchange their positions.
*/

% s( Node, SuccessorNode, Cost)

s( [Empty | Tiles], [Tile | Tiles1], 1)  :-  % All arc costs are 1
  swap( Empty, Tile, Tiles, Tiles1).         % Swap Empty and Tile in Tiles 

swap( Empty, Tile, [Tile | Ts], [Empty | Ts] )  :-
  mandist( Empty, Tile, 1).                  % Manhattan distance = 1

swap( Empty, Tile, [T1 | Ts], [T1 | Ts1] )  :-
  swap( Empty, Tile, Ts, Ts1).

mandist( X/Y, X1/Y1, D)  :-          % D is Manhhattan dist. between two squares
  dif( X, X1, Dx),
  dif( Y, Y1, Dy),
  D is Dx + Dy.

dif( A, B, D)  :-              % D is |A-B|
  D is A-B, D >= 0, !
  ;
  D is B-A.

% Heuristic estimate h is the sum of distances of each tile
% from its "home' square plus 3 times "sequence' score

h( [Empty | Tiles], H)  :-
  goal( [Empty1 | GoalSquares] ), ç
  totdist( Tiles, GoalSquares, D),      % Total distance from home squares
  seq( Tiles, S),                       % Sequence score
  H is D + 3*S.

totdist( [], [], 0).

totdist( [Tile | Tiles], [Square | Squares], D)  :-
  mandist( Tile, Square, D1),
  totdist( Tiles, Squares, D2),
  D is D1 + D2.

% seq( TilePositions, Score): sequence score

seq( [First | OtherTiles], S)  :-
  seq( [First | OtherTiles ], First, S).

seq( [Tile1, Tile2 | Tiles], First, S)  :-
  score( Tile1, Tile2, S1),
  seq( [Tile2 | Tiles], First, S2),
  S is S1 + S2.

seq( [Last], First, S)  :-
  score( Last, First, S).

score( 2/2, _, 1)  :-  !.              % Tile in centre scores 1

score( 1/3, 2/3, 0)  :-  !.            % Proper successor scores 0
score( 2/3, 3/3, 0)  :-  !.
score( 3/3, 3/2, 0)  :-  !.
score( 3/2, 3/1, 0)  :-  !.
score( 3/1, 2/1, 0)  :-  !.
score( 2/1, 1/1, 0)  :-  !.
score( 1/1, 1/2, 0)  :-  !.
score( 1/2, 1/3, 0)  :-  !.

score( _, _, 2).                       % Tiles out of sequence score 2

goal( [2/2,1/3,2/3,3/3,3/2,3/1,2/1,1/1,1/2] ).  % Goal squares for tiles

% Display a solution path as a list of board positions

showsol( [] ).

showsol( [P | L] )  :-
  showsol( L),
  nl, write( '---'),
  showpos( P).

% Display a board position

showpos( [S0,S1,S2,S3,S4,S5,S6,S7,S8] )  :-
  member( Y, [3,2,1] ),                           % Order of Y-coordinates
  nl, member( X, [1,2,3] ),                       % Order of X-coordinates
  member( Tile-X/Y,                               % Tile on square X/Y
          [' '-S0,1-S1,2-S2,3-S3,4-S4,5-S5,6-S6,7-S7,8-S8] ),
  write( Tile),
  fail                                            % Backtrack to next square
  ;
  true.                                           % All squares done

% Starting positions for some puzzles

start1( [2/2,1/3,3/2,2/3,3/3,3/1,2/1,1/1,1/2] ).  % Requires 4 steps

start2( [2/1,1/2,1/3,3/3,3/2,3/1,2/2,1/1,2/3] ).  % Requires 5 steps

start3( [2/2,2/3,1/3,3/1,1/2,2/1,3/3,1/1,3/2] ).  % Requires 18 steps

% An example query: ?- start1( Pos), bestfirst( Pos, Sol), showsol( Sol).

