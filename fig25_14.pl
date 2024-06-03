%  Figure 25.14  A pattern-directed program for simple resolution
%  theorem proving.

% The following directive is required by some Prologs

:- dynamic clause/1, done/3.

:- op( 120, yfx, v).		% Disjunction

% Production rules for resolution theorem proving

% Contradicting clauses

[ clause( X), clause( ~X) ] --->
[ write('Contradiction found'), stop].

% Remove a true clause

[ clause( C), in( P, C), in( ~P, C) ]  --->
[ retract( C) ].

% Simplify a clause

[ clause( C), delete( P, C, C1), in( P, C1) ]  --->
[ replace( clause( C), clause( C1)) ].

% Resolution step, a special case

[ clause( P), clause( C), delete( ~P, C, C1), \+ done( P, C, P) ] --->
[ assert( clause( C1)), assert( done( P, C, P)) ].

% Resolution step, a special case

[ clause( ~P), clause( C), delete( P, C, C1), \+ done( ~P, C, P) ] --->
[ assert( clause( C1)), assert( done( ~P, C, P)) ].

% Resolution step, general case

[ clause(C1), delete( P, C1, CA),
  clause(C2), delete( ~P, C2, CB),  \+ done( C1,C2,P) ]  --->
[ assert( clause(CA v CB)), assert( done( C1, C2, P)) ].

% Last rule: resolution process stuck

[] ---> [ write('Not contradiction'), stop].


% delete( P, E, E1)  if
%   deleting a disjunctive subexpression P from E gives E1

delete( X, X v Y, Y).

delete( X, Y v X, Y).

delete( X, Y v Z, Y v Z1)  :-
  delete( X, Z, Z1).

delete( X, Y v Z, Y1 v Z)  :-
  delete( X, Y, Y1).

% in( P, E)  if P is a disjunctive subexpression in E

in( X, X).

in( X, Y)  :-
  delete( X, Y, _).
