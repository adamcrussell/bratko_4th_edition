% Figure 9.22   Finding a spanning tree of a graph: an `algorithmic' % program. The program assumes that the graph is connected.


% Finding a spanning tree of a graph
%
% Trees and graphs are represented by lists of their edges.
% For example: Graph = [a-b, b-c, b-d, c-d]

% stree( Graph, Tree): Tree is a spanning tree of Graph

stree( Graph, Tree)  :-
   member( Edge, Graph),
   spread( [Edge], Tree, Graph).

% spread( Tree1, Tree, Graph): Tree1 `spreads to' spanning tree Tree of Graph

spread( Tree1, Tree, Graph)  :-
   addedge( Tree1, Tree2, Graph),
   spread( Tree2, Tree, Graph).

spread( Tree, Tree, Graph)  :-
   \+ addedge( Tree, _, Graph). % No edge can be added without creating a cycle

% addedge( Tree, NewTree, Graph):
%   add an edge from Graph to Tree without creating a cycle

addedge( Tree, [A-B | Tree], Graph)  :-
  adjacent( A, B, Graph),          % Nodes A and B adjacent in Graph   
  node( A, Tree),                  % A in Tree   
  \+ node( B, Tree).              % A-B doesn't create a cycle in Tree 

adjacent( Node1, Node2, Graph)  :-
  member( Node1-Node2, Graph)
  ;
  member( Node2-Node1, Graph).

node( Node, Graph)  :-             % Node is a node in Graph if   
  adjacent( Node, _, Graph).       % Node is adjacent to anything in Graph
 
