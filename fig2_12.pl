% Four versions of the ancestor program

% The original version

anc1( X, Z) :-
  parent( X, Z).

anc1( X, Z) :-
  parent( X, Y),
  anc1( Y, Z).

% Variation 1: swap clauses of the original version

anc2( X, Z) :-
  parent( X, Y),
  anc2( Y, Z).

anc2( X, Z) :-
  parent( X, Z).

% Variation 2: swap goals in second clause of the original version

anc3( X, Z) :-
  parent( X, Z).

anc3( X, Z) :-
  anc3( X, Y),
  parent( Y, Z).

% Variation 3: swap goals and clauses of the original version

anc4( X, Z) :-
  anc4( X, Y),
  parent( Y, Z).

anc4( X, Z) :-
  parent( X, Z).
