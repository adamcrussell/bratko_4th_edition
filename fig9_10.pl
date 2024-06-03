% Figure 9.10  Inserting an item as a leaf into the binary dictionary.

% addleaf( Tree, X, NewTree):
%   inserting X as a leaf into binary dictionary Tree gives NewTree

addleaf( nil, X, t( nil, X, nil)).

addleaf( t( Left, X, Right), X, t( Left, X, Right)).

addleaf( t( Left, Root, Right), X, t( Left1, Root, Right))  :-
  gt( Root, X),
  addleaf( Left, X, Left1).

addleaf( t( Left, Root, Right), X, t( Left, Root, Right1))  :-
  gt( X, Root),
  addleaf( Right, X, Right1).
