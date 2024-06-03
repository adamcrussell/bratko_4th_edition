% Figure  25.3  Top level of an interpreter for CLP.

solve( Goal)  :-
  solve( Goal, [ ], Constr).       % Start with empty constraints, Constr is sufficient condition for Goal

% solve( Goal, InputConstraints, OutputConstraints)

solve( true, Constr0, Constr0).			% “true” is trivially solved, no change in constraints 

solve( (G1, G2), Constr0, Constr)  :-  !,	% Conjunction of goals G1 and G2
  solve( G1, Constr0, Constr1),			% Constr1 is condition for G1 and Constr0
  solve( G2, Constr1, Constr).			% Constr is condition for G2 and Constr1 

solve( G, Constr0, Constr)  :-
  prolog_goal( G),                    		% G is a Prolog goal 
  clause( G, Body),                  		% A clause about G 
  solve( Body, Constr0, Constr).

solve( G, Constr0, Constr)  :-
  constraint_goal( G),             		% G is a constraint goal
  merge_constraints( Constr0, G, Constr).	% Add G to Constr0 and check satisfiability
