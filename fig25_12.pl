%  Figure 25.12:  A small interpreter for pattern-directed programs.


%   A small interpreter for pattern-directed programs
%   The system's database is manipulated through assert/retract


:-  op( 800, xfx, --->).

% run: execute production rules of the form
%      Condition ---> Action until action `stop' is triggered

run  :-
  Condition ---> Action,         % A production rule
  test( Condition),              % Precondition satisfied?
  execute( Action).

% test( [ Condition1, Condition2, ...])  if all conditions true

test( []).                       % Empty condition

test( [First|Rest])  :-          % Test conjunctive condition
  call( First),
  test( Rest).

% execute( [ Action1, Action2, ...]): execute list of actions

execute( [ stop])  :-  !.         % Stop execution

execute( [])  :-                 % Empty action (execution cycle completed)
  run.                           % Continue with next execution cycle

execute( [First | Rest])  :-
  call( First),
  execute( Rest).

replace( A, B)  :-               % Replace A with B in database
  retract( A), !,                % Retract once only
  assert( B).
