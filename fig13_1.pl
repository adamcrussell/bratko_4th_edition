% Figure 13.1:  An implementation of the IDA* algorithm.


% idastar( Start, Solution):
%   Perform IDA* search; Start is the start node, Solution is solution path

idastar( Start, Solution)  :-
  retract( next_bound(_)), fail     % Clear next_bound
  ;
  asserta( next_bound( 0)),         % Initialise bound
  idastar0( Start, Solution).
  
idastar0( Start, Sol)  :-
  retract( next_bound( Bound)),     % Current bound
  asserta( next_bound( 99999)),     % Initialise next bound
  f( Start, F),                     % f-value of start node
  df( [Start], F, Bound, Sol)       % Find solution; if not, change bound
  ;
  next_bound( NextBound),
  NextBound < 99999,               % Bound finite
  idastar0( Start, Sol).           % Try with new bound

% df( Path, F, Bound, Sol):
%  Perform depth-first search within Bound
%  Path is the path from start node so far (in reverse order)
%  F is the f-value of the current node, i.e. the head of Path

df( [N | Ns], F, Bound, [N | Ns])  :-
  F =< Bound,
  goal( N).                        % Succeed: solution found

df( [N | Ns], F, Bound, Sol)  :-
  F =< Bound,                      % Node N within f-bound
  s( N, N1), \+ member( N1, Ns),   % Expand N
  f( N1, F1),
  df( [N1,N | Ns], F1, Bound, Sol).

df( _, F, Bound, _)  :-
  F > Bound,                       % Beyond Bound
  update_next_bound( F),           % Just update next bound
  fail.                            % and fail

update_next_bound( F)  :-
  next_bound( Bound),
  Bound =< F, !                      % Do not change next bound
  ;
  retract( next_bound( Bound)), !,   % Lower next bound
  asserta( next_bound( F)).

