% Figure 9.15  Insertion into the binary dictionary at any level of the tree.


% add( Tree, X, NewTree):
%   inserting X at any level of binary dictionary Tree gives NewTree

add( Tree, X, NewTree)  :-
   addroot( Tree, X, NewTree).               % Add X as new root

add( t( L, Y, R), X, t( L1, Y, R))  :-       % Insert X into left subtree
   gt( Y, X),
   add( L, X, L1).

add( t( L, Y, R), X, t( L, Y, R1))  :-       % Insert X into right subtree
   gt( X, Y),
   add( R, X, R1).

% addroot( Tree, X, NewTree):
%   inserting X as the root into Tree gives NewTree

addroot( nil, X, t( nil, X, nil)).           % Insert into empty tree

addroot( t( L, Y, R), X, t( L1, X, t( L2, Y, R)))  :-
   gt( Y, X),
   addroot( L, X, t( L1, X, L2)).

addroot( t( L, Y, R), X, t( t( L, Y, R1), X, R2))  :-
   gt( X, Y),
   addroot( R, X, t( R1, X, R2)).
