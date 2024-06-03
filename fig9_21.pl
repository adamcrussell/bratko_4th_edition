% Figure 9.21   Path-finding in a graph:  Path is 
% an acyclic path with cost Cost from A to Z in Graph.


% path( A, Z, Graph, Path, Cost):
%    Path is an acyclic path with cost Cost from A to Z in Graph

path( A, Z, Graph, Path, Cost)  :-
  path1( A, [Z], 0, Graph, Path, Cost).

path1( A, [A | Path1], Cost1, Graph, [A | Path1], Cost1).

path1( A, [Y | Path1], Cost1, Graph, Path, Cost)  :-
   adjacent( X, Y, CostXY, Graph),
   \+ member( X, Path1),
   Cost2 is Cost1 + CostXY,
   path1( A, [X, Y | Path1], Cost2, Graph, Path, Cost).
