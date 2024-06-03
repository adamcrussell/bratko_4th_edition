% Figure 17.7  A state-space definition for means-ends planning based on goal
% regression. Relations satisfied, achieves, preserves, regress, addnew and
% delete_all are as defined in Figure 17.6.


% State space representation of means-ends planning with goal regression

:- op( 300, xfy, ->).

s( Goals -> NextAction, NewGoals -> Action, 1)  :-   % All costs are 1
  member( Goal, Goals),
  achieves( Action, Goal),
  can( Action, Condition),
  preserves( Action, Goals),
  regress( Goals, Action, NewGoals).

goal( Goals -> Action) :-
  start( State),                    	     % User-defined initial situation
  satisfied( State, Goals).         	     % Goals true in initial situation

h( Goals -> Action, H)  :-                   % Heuristic estimate
  start( State),
  delete_all( Goals, State, Unsatisfied),    % Unsatisfied goals
  length( Unsatisfied, H).                   % Number of unsatisfied goals

