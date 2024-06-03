%   Figure  17.6  A planner based on goal regression. 
%   This planner searches in iterative-deepening style.

%   A means-ends planner with goal regression

%   plan( State, Goals, Plan)

plan( State, Goals, [])  :-
  satisfied( State, Goals).                   % Goals true in State

plan( State, Goals, Plan)  :-
  conc( PrePlan, [Action], Plan),             % Divide plan achieving breadth-first effect
  select( State, Goals, Goal),                % Select a goal
  achieves( Action, Goal),
  can( Action, Condition),                    % Ensure Action contains no variables
  preserves( Action, Goals),                  % Protect Goals
  regress( Goals, Action, RegressedGoals),    % Regress Goals through Action
  plan( State, RegressedGoals, PrePlan).

satisfied( State, Goals)  :-
  delete_all( Goals, State, []).              % All Goals in State

select( State, Goals, Goal)  :-               % Select Goal from Goals
  member( Goal, Goals).                       % A simple selection principle

achieves( Action, Goal)  :-
  adds( Action, Goals),
  member( Goal, Goals).

preserves( Action, Goals)  :-                 % Action does not destroy Goals
  deletes( Action, Relations),
  not (member( Goal, Relations),
       member( Goal, Goals) ).

regress( Goals, Action, RegressedGoals)  :-       % Regress Goals through Action
  adds( Action, NewRelations),
  delete_all( Goals, NewRelations, RestGoals),
  can( Action, Condition),
  addnew( Condition, RestGoals, RegressedGoals).  % Add precond., check imposs.

% addnew( NewGoals, OldGoals, AllGoals):
%   AllGoals is the union of NewGoals and OldGoals
%   NewGoals and OldGoals must be compatible

addnew( [], L, L).

addnew( [Goal | _], Goals, _)  :-
  impossible( Goal, Goals),         % Goal incompatible with Goals
  !, 
  fail.                             % Cannot be added

addnew( [X | L1], L2, L3)  :-
  member( X, L2),  !,               % Ignore duplicate
  addnew( L1, L2, L3).

addnew( [X | L1], L2, [X | L3])  :-
  addnew( L1, L2, L3).

% delete_all( L1, L2, Diff): Diff is set-difference of lists L1 and L2

delete_all( [], _, []).

delete_all( [X | L1], L2, Diff)  :-
  member( X, L2), !,
  delete_all( L1, L2, Diff).

delete_all( [X | L1], L2, [X | Diff])  :-
  delete_all( L1, L2, Diff).
