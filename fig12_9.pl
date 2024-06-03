% Figure 12.9  Problem-specific relations for the task-scheduling problem. 
% The particular scheduling problem of Figure 12.8 is also defined by its 
% precedence graph and an initial (empty) schedule as a start node for search.


/* Problem-specific relations for task scheduling

Nodes in the state space are partial schedules specified by:

[ WaitingTask1/D1, WaitingTask2/D2, ...] * ç
[ Task1/F1, Task2/F2, ...] * FinTime

The first list specifies the waiting tasks and their durations; the ç
second list specifies the currently executed tasks and their finishing ç
times, ordered so that F1 =< F2, F2 =< F3 ...  . Fintime is the ç
latest completion time of current engagements of the processors.
*/

% s( Node, SuccessorNode, Cost)

s( Tasks1 * [_/F | Active1] * Fin1, Tasks2 * Active2 * Fin2, Cost)  :-
  del( Task/D, Tasks1, Tasks2),                                % Pick a waiting task
  \+ ( member( T/_, Tasks2), before( T, Task) ),              % Check precedence
  \+ ( member( T1/F1, Active1), F < F1, before( T1, Task) ),  %Active tasks too
  Time is F + D,  % Finishing time of activated task
  insert( Task/Time, Active1, Active2, Fin1, Fin2),
  Cost is Fin2 - Fin1.

s( Tasks * [_/F | Active1] * Fin, Tasks * Active2 * Fin, 0)  :-
  insertidle( F, Active1, Active2).                            % Leave processor idle

before( T1, T2)  :-               % Task T1 before T2 according to precedence
  prec( T1, T2).

before( T1, T2)  :-
  prec( T, T2),
  before( T1, T).

insert( S/A, [T/B | L], [S/A, T/B | L], F, F)  :-              % Task lists are ordered
  A =< B, !.

insert( S/A, [T/B | L], [T/B | L1], F1, F2)  :-
  insert( S/A, L, L1, F1, F2).

insert( S/A, [], [S/A], _, A).

insertidle( A, [T/B | L], [idle/B, T/B | L] )  :-              % Leave processor idle
  A < B, !.                            % until first greater finishing time

insertidle( A, [T/B | L], [T/B | L1] )  :-
  insertidle( A, L, L1).

del( A, [A | L], L).                   % Delete item from list

del( A, [B | L], [B | L1] )  :-
  del( A, L, L1).

goal( [] * _ * _).                     % Goal state: no task waiting

% Heuristic estimate of a partial schedule is based on an
% optimistic estimate of the final finishing time of this
% partial schedule extended by all the remaining waiting tasks.

h( Tasks * Processors * Fin, H)  :-
  totaltime( Tasks, Tottime),          % Total duration of waiting tasks
  sumnum( Processors, Ftime, N),       % Ftime is sum of finishing times
                                       % of processors, N is their number
  Finall is ( Tottime + Ftime)/N,
  ( Finall > Fin, !, H is Finall - Fin
    ; 
    H = 0
  ).

totaltime( [], 0).

totaltime( [_/D | Tasks], T)  :-
  totaltime( Tasks, T1),
  T is T1 + D.

sumnum( [], 0, 0).

sumnum( [_/T | Procs], FT, N)  :-
  sumnum( Procs, FT1, N1),
  N is N1 + 1,
  FT is FT1 + T.

% A task-precedence graph

prec( t1, t4). prec( t1, t5). prec( t2, t4). prec( t2, t5).
prec( t3, t5). prec( t3, t6). prec( t3, t7).

% A start node

start( [t1/4, t2/2, t3/2, t4/20, t5/20, t6/11, t7/11] * [idle/0, idle/0, idle/0] * 0).

% An example query: start( Problem), bestfirst( Problem, Sol).

