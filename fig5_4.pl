% Figure 5.4  Another eight queens program.


solution( [ ] ).

solution( [X/Y | Others] ) :-
  solution( Others),
  member( Y, [1,2,3,4,5,6,7,8] ),	% Usual member predicate
  not attacks( X/Y, Others).

attacks( X/Y, Others) :-
    member( X1/Y1, Others),
    (	Y1 = Y;
	Y1 is Y + X1 - X;
	Y1 is Y - X1 + X).

