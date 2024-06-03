% Figure 14.8: Depth-first search for AND/OR graphs. This program
% does not avoid infinite cycling. Procedure 'solve' finds a solution 
% tree, procedure 'show' displayes such a tree. 'show' assumes that 
% each node on output only takes one character on output.


%  Depth-first AND/OR search
%  solve( Node, SolutionTree):
%    find a solution tree for Node in an AND/OR graph

:-  op( 500, xfx, :).
:-  op( 600, xfx, ---> ).

solve( Node, Node)  :-              % Solution tree of goal node is Node itself
  goal(Node).

solve( Node, Node ---> Tree)  :-
  Node ---> or:Nodes,               % Node is an OR-node
  member( Node1, Nodes),            % Select a successor Node1 of Node
  solve( Node1, Tree).

solve( Node, Node ---> and:Trees)  :-
  Node ---> and:Nodes,              % Node is an AND-node
  solveall( Nodes, Trees).          % Solve all Node's successors

% solveall( [Node1,Node2, ...], [SolutionTree1,SolutionTree2, ...])

solveall( [], []).

solveall( [Node|Nodes], [Tree|Trees])  :-
  solve( Node, Tree),
  solveall( Nodes, Trees).

%  Displaying a solution tree

show(Tree)  :-                   % Display solution tree
  show(Tree,0), !.               % Indented by 0

% show( Tree, H): display solution tree indented by H

show( Node ---> Tree, H)  :-  !,
  write(Node), write(' ---> '),
  H1 is H + 7,
  show( Tree, H1).

show( and:[T], H)  :-  !,        % Display single AND tree
  show(T,H).

show( and:[T|Ts], H)  :-  !,     % Display AND-list of solution trees
  show( T, H),
  tab(H),
  show( and:Ts, H).

show( Node, H) :-
  write(Node), nl.
