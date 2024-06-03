% Figure 21.9  Learning about a path in a graph.


% Learning about path: path(StartNode,GoalNode,Path)

% A directed graph

link(a,b).
link(a,c).
link(b,c).
link(b,d).
link(d,e).

backliteral( link(X,Y), [ X:item], [ Y:item]). 
backliteral( path(X,Y,L), [ X:item], [ Y:item, L:list]).

term( list, [X|L], [ X:item, L:list]).
term( list, [], []).

prolog_predicate( link(X,Y)).

start_clause( [ path(X,Y,L)] / [X:item,Y:item,L:list] ).

% Examples

ex( path( a, a, [a])).
ex( path( b, b, [b])).
ex( path( e, e, [e])).
ex( path( f, f, [f])).
ex( path( a, c, [a,c])).
ex( path( b, e, [b,d,e])).
ex( path( a, e, [a,b,d,e])).

nex( path( a, a, [])).
nex( path( a, a, [b])).
nex( path( a, a, [b,b])).
nex( path( e, d, [e,d])).
nex( path( a, d, [a,b,c])).
nex( path( a, c, [a])).
nex( path( a, c, [a,c,a,c])).
nex( path( a, d, [a,d])).
