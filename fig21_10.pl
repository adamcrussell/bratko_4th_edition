% Figure 21.10  Learning insertion sort.


% Learning sort

backliteral( sort( L, S), [L:list], [S:list]).
backliteral( insert_sorted( X, L1, L2), [X:item, L1:list], [L2:list]).

term( list, [X | L], [X:item, L:list]).
term( list, [], []).

prolog_predicate( insert_sorted( X, L0, L)).
prolog_predicate( X=Y).

start_clause( [sort(L1,L2)] / [L1:list, L2:list] ).

ex( sort( [], [])).
ex( sort( [a], [a])).
ex( [ sort( [c,a,b], L), L = [a,b,c] ] ).   % Uninstantiated 2nd arg. of sort!
ex( sort( [b,a,c], [a,b,c])).
ex( sort( [c,d,b,e,a], [a,b,c,d,e])).
ex( sort( [a,d,c,b], [a,b,c,d])).

nex( sort( [], [a])).
nex( sort( [a,b], [a])).
nex( sort( [a,c], [b,c])).
nex( sort( [b,a,d,c], [b,a,d,c])).
nex( sort( [a,c,b], [a,c,b])).
nex( sort( [], [b,c,d])).

insert_sorted( X, L, _) :-     % Guarding clause: test instantiation of args.
  var(X), !, fail
  ;
  var( L), !, fail
  ; 
  L = [Y|_], var(Y), !, fail.

insert_sorted( X, [], [X])  :-  !.

insert_sorted( X, [Y | L], [X,Y | L])  :-
  X @< Y, !.           % term X "lexicographically precedes" term Y 

insert_sorted( X, [Y | L], [Y | L1])  :-
  insert_sorted( X, L, L1).
