%  Figure 23.6  A DCG handling the syntax and meaning of a small
%  subset of natural language.


:-  op( 100, xfy, and).
:-  op( 150, xfy, =>).

sentence( S)  -->
  noun_phrase( X, P, S), verb_phrase( X, P).

noun_phrase( X, P, S)  -->
  determiner( X, P12, P, S), noun( X, P1), rel_clause( X, P1, P12).

noun_phrase( X, P, P)  -->
  proper_noun( X).

verb_phrase( X, P)  -->
  trans_verb( X, Y, P1), noun_phrase( Y, P1, P).

verb_phrase( X, P)  -->
  intrans_verb( X, P).

rel_clause( X, P1, P1 and P2)  -->
  [that], verb_phrase( X, P2).

rel_clause( X, P1, P1)  --> [].

determiner( X, P1, P, all( X, P1 => P))  --> [every].

determiner( X, P1, P, exists( X, P1 and P)) --> [a].

noun( X, man(X))  -->  [man].

noun( X, woman(X))  -->  [woman].

proper_noun( john)  -->  [john].

proper_noun( annie)  -->  [annie].

proper_noun( monet)  -->  [monet].

trans_verb( X, Y, likes( X, Y))  -->  [ likes].

trans_verb( X, Y, admires( X, Y))  -->  [admires].

intrans_verb( X, paints(X))  -->  [paints].

% Some tests

test1( M)  :-
  sentence( M, [john,paints],[]).

test2( M)  :-
  sentence( M, [a, man, paints], []).

test3( M)  :-
  sentence( M, [every,man,that,paints,admires,monet],[]).

test4( M)  :-
  sentence( M, [annie,admires,every,man,that,paints],[]).

test5( M)  :-
  sentence( M, [every,woman,that,admires,a,man,that,paints,likes,monet],[]).
