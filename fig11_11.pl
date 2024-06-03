% Figure 11.11  A more efficient program than that of Figure 11.10 for 
% the breadth-first search. The improvement is based on using 
% the difference-pair representation for the list of candidate paths. 
% Procedure extend is as in Figure 11.10.


% solve( Start, Solution):
%   Solution is a path (in reverse order) from Start to a goal

solve( Start, Solution)  :-
  breadthfirst( [ [Start] | Z] - Z, Solution).

breadthfirst( [ [Node | Path] | _] - _, [Node | Path] )  :-
  goal( Node).

breadthfirst( [Path | Paths] - Z, Solution)  :-
  extend( Path, NewPaths),
  conc( NewPaths, Z1, Z),              % Add NewPaths at end
  Paths \== Z1,                        % Set of candidates not empty
  breadthfirst( Paths - Z1, Solution).