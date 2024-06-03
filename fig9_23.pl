% Figure 9.23   Finding a spanning tree of a graph: a `declarative' 
% program. Relations node and adjacent are as in Figure 9.22.


% Finding a spanning tree
% Graphs and trees are represented as lists of edges.

% stree( Graph, Tree): Tree is a spanning tree of Graph

stree( Graph, Tree)  :-
  subset( Graph, Tree),
  tree( Tree),
  covers( Tree, Graph).

tree( Tree)  :-
  connected( Tree),
  \+ hasacycle( Tree).

% connected( Graph): there is a path between any two nodes in Graph

connected( Graph)  :-
  \+ ( node( A, Graph), node( B, Graph), \+ path( A, B, Graph, _) ).

hasacycle( Graph)  :-
   adjacent( Node1, Node2, Graph),
   path( Node1, Node2, Graph, [Node1, X, Y | _] ). % Path of length > 1 

% covers( Tree, Graph): every node of Graph is in Tree

covers( Tree, Graph)  :-
  \+ ( node( Node, Graph), \+ node( Node, Tree) ).

% subset( List1, List2): List2 represents a subset of List1

subset( [], [] ). 

subset( [X | Set], Subset)  :-            % X not in subset
  subset( Set, Subset).

subset( [X | Set], [X | Subset])  :-      % X included in subset
  subset( Set, Subset).


