% Appendix B

% File frequent.pl: Library of frequently used predicates

% The listing below includes some predicates that 
% may already be included among the built-in predicates, 
% depending on the implementation of Prolog. 
% For example, negation as failure written as not Goal 
% is also included below for compatibility with Prologs 
% that use the notation \+ Goal instead. 
% When loading into Prolog the definition of a predicate that 
% is already built-in, Prolog will typically just issue a 
% warning message and ignore the new definition.

% Negation as failure 
%   This is often available as a built-in predicate,
%   often written with the prefix operator "\+", e.g. \+ likes(mary,snakes)
%   The definition below is only given for compatibility among Prolog implementations

:- op( 900, fy, not).

not Goal  :-
  Goal, !, fail
  ; 
  true.
 

% once( Goal): produce one solution of Goal only (the first solution only)
%   This may already be provided as a built-in predicate

once( Goal)  :-
  Goal, !.

% member( X, List): X is a member of List
%   This may already be provided as a built-in predicate

member(X,[X | _]).                 % X is head of list

member( X, [ _ | Rest])  :-         
  member( X, Rest).                % X is in body of list

%  conc( L1, L2, L3): list L3 is the concatenation of lists L1 and L2

conc( [], L, L).

conc( [X | L1], L2, [X | L3])  :-
  conc( L1, L2, L3).

% del( X, L0, L): List L is equal to list L0 with X deleted
%   Note: Only one occurrence of X is deleted
%   Fail if X is not in L0 

del( X, [X | Rest], Rest).                                % Delete the head

del( X, [Y | Rest0], [Y | Rest])  :-
  del( X, Rest0, Rest).                                    % Delete from tail

%  subset( Set, Subset):  list Set contains all the elements of list Subset 
%    Note: The elements of Subset appear in Set in the same order as in Subset

subset( [], []).

subset( [First | Rest], [First | Sub])  :-        % Retain First in subset
  subset( Rest, Sub).

subset( [First | Rest], Sub)  :-                     % Remove First
  subset( Rest, Sub).

%  set_difference( Set1, Set2, Set3):  Set3 is the list representing 
%    the difference of the sets represented by lists Set1 and Set2
%    Normal use: Set1 and Set2 are input arguments, Set3 is output

set_difference( [], _, []).

set_difference( [X | S1], S2, S3)  :-
  member( X, S2),  !,                                      % X in set S2
  set_difference( S1, S2, S3).

set_difference( [X | S1], S2, [X | S3])  :-      % X not in S2
  set_difference( S1, S2, S3).

%  length( List, Length): Lentgh is the length of List
%    Note: length/2 may already be included among built-in predicates
%    The definition below is tail-recursive 
%    It can also be used to generate efficiently list of given length

length( L, N)  :-
  length( L, 0, N).

length( [], N, N).

length( [_ | L], N0, N)  :-
  N1 is N0 + 1,
  length( L, N1, N).

%  max( X, Y, Max): Max = max(X,Y)

max( X, Y, Max)  :-
  X >= Y, !, Max = X
  ;
  Max = Y.

%  min( X, Y, Min): Min = min(X,Y) 

min( X, Y, Min)  :-
  X =< Y, !, Min = X
  ;
  Min = Y.

% copy_term( T1, T2): term T2 is equal to T1 with variables renamed
% This may already be available as a built-in predicate
% Procedure below assumes that copy_term is called so that T2 matches T1

copy_term( Term, Copy)  :-
  asserta( term_to_copy( Term)),
  retract( term_to_copy( Copy)), !.

% tab( N): write string of N blanks on current output stream
% This may be already available as a built-in predicate

tab( N)  :-
  N < 1, !.

tab( N)  :-
   N > 0,
   write( ' '),
   N1 is N - 1,
   tab( N1).

 
% time( DT):
%   DT is Prolog execution time in miliseconds 
%   between the call of time/1 and the previous call of time/1

time(DT)  :- 
   statistics(runtime, [_,DT]).
