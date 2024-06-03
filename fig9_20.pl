% Figure 9.20  Finding an acyclic path, Path, from A to Z in Graph.


% path( A, Z, Graph, Path): Path is an acyclic path from A to Z in Graph

path( A, Z, Graph, Path)  :-
  path1( A, [Z], Graph, Path).

path1( A, [A | Path1], _, [A | Path1] ).

path1( A, [Y | Path1], Graph, Path)  :-
  adjacent( X, Y, Graph),
  \+ member( X, Path1),                        % No-cycle condition
  path1( A, [X, Y | Path1], Graph, Path).
