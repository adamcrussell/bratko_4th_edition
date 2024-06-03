% Figure 11.8   A depth-limited, depth-first search program.


% depthfirst2( Node, Solution, Maxdepth):
%   Solution is a path, not longer than Maxdepth, from Node to a goal

depthfirst2( Node, [Node], _)  :-
   goal( Node).

depthfirst2( Node, [Node | Sol], Maxdepth)  :-
   Maxdepth > 0,
   s( Node, Node1),
   Max1 is Maxdepth - 1,
   depthfirst2( Node1, Sol, Max1).


