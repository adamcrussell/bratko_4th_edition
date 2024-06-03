% Figure 9.13  Deleting from the binary dictionary.


% del( Tree, X, NewTree):
%   deleting X from binary dictionary Tree gives NewTree

del( t( nil, X, Right), X, Right).

del( t( Left, X, nil), X, Left).

del( t( Left, X, Right), X, t( Left, Y, Right1))  :-
   delmin( Right, Y, Right1).

del( t( Left, Root, Right), X, t( Left1, Root, Right))  :-
   gt( Root, X),
   del( Left, X, Left1).

del( t( Left, Root, Right), X, t( Left, Root, Right1))  :-
   gt( X, Root),
   del( Right, X, Right1).

% delmin( Tree, Y, NewTree):
%   delete minimal item Y in binary dictionary Tree producing NewTree

delmin( t( nil, Y, R), Y, R).

delmin( t( Left, Root, Right), Y, t( Left1, Root, Right))  :-
   delmin( Left, Y, Left1).
