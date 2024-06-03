% Figure 9.7  Finding an item X in a binary dictionary.


% in( X, Tree): X in binary dictionary Tree

in( X, t( _, X, _) ).

in( X, t( Left, Root, Right) )  :-
  gt( Root, X),                    % Root greater than X
  in( X, Left).                    % Search left subtree 

in( X, t( Left, Root, Right) )  :-
  gt( X, Root),                    % X greater than Root
  in( X, Right).                   % Search right subtree
