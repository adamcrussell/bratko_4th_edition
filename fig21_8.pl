% Figure 21.8  Learning about odd-length and even-length simultaneously.

% Inducing odd and even length for lists

backliteral( even( L), [ L:list], []).
backliteral( odd( L), [ L:list], []).

term( list, [X|L], [ X:item, L:list]).
term( list, [], []).

prolog_predicate( fail).

start_clause([ odd( L) ] / [ L:list]).
start_clause([ even( L) ] / [ L:list]).

ex( even( [])).
ex( even( [a,b])).
ex( odd( [a])).
ex( odd( [b,c,d])).
ex( odd( [a,b,c,d,e])).
ex( even( [a,b,c,d])).

nex( even( [a])).
nex( even( [a,b,c])).
nex( odd( [])).
nex( odd( [a,b])).
nex( odd( [a,b,c,d])).
