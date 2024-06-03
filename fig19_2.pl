% Figure 19.2  A CLP(R) scheduling program for problems with precedence and resource 
% constraints.


% Scheduling with CLP with limited resources

schedule( BestSchedule, BestTime)  :-
  tasks( TasksDurs),
  precedence_constr( TasksDurs, Schedule, FinTime),   % Set up precedence inequalities
  initialize_bound,                                   % Initialize bound on finishing time
  assign_processors( Schedule, FinTime),              % Assign processors to tasks
  minimize( FinTime),
  update_bound( Schedule, FinTime),                   
  fail                                                % Backtrack to find more schedules
  ;
  bestsofar( BestSchedule, BestTime).                 % Final best

% precedence_constr( TasksDurs, Schedule, FinTime):
%   For given tasks and their durations, construct a structure Schedule
%   comprising start time variables. These variables and finishing time FinTime
%   are constrained by inequalities due to precedences.

precedence_constr( [], [], FinTime).

precedence_constr( [T/D | TDs], [T/Proc/Start/D | Rest], FinTime)  :-
  { Start >= 0,                                       % Earliest start at 0
    Start + D =< FinTime },                           % Must finish by FinTime
  precedence_constr( TDs, Rest, FinTime),      
  prec_constr( T/Proc/Start/D, Rest).

prec_constr( _, []).

prec_constr( T/P/S/D, [T1/P1/S1/D1 | Rest])  :-
  (  prec( T, T1), !, { S+D =< S1}
     ;
     prec( T1, T), !, { S1+D1 =< S}
     ;
     true ),
  prec_constr( T/P/S/D, Rest).

% assign_processors( Schedule, FinTime):
%   Assign processors to tasks in Schedule

assign_processors( [], FinTime).

assign_processors( [T/P/S/D | Rest], FinTime)  :-
  assign_processors( Rest, FinTime),
  resource( T, Processors),             % T can be executed by any of Processors
  member( P, Processors),               % Choose one of suitable processors
  resource_constr( T/P/S/D, Rest),      % Impose resource constraints
  bestsofar( _, BestTimeSoFar),
  { FinTime < BestTimeSoFar }.          % New schedule better than best so far

% resource_constr( ScheduledTask, TaskList):
%   Construct constraints to ensure no resource conflict 
%   between ScheduledTask and TaskList

resource_constr( _, []).

resource_constr( Task, [Task1 | Rest])  :-
  no_conflict( Task, Task1),
  resource_constr( Task, Rest).

no_conflict( T/P/S/D, T1/P1/S1/D1)  :-
  P \== P1, !                     % Different processors
  ;
  prec( T, T1), !                 % Already constrained
  ;
  prec( T1, T), !                 % Already constrained
  ;
  {  S+D =< S1                    % Same processor, no time overlap
     ;
     S1+D1 =< S}.
  
initialize_bound  :-
  retract(bestsofar(_,_)), fail
  ;
  assert( bestsofar( dummy_schedule, 9999)).    % Assuming 9999 > any finishing time

% update_bound( Schedule, FinTime):
%   update best schedule and time 

update_bound( Schedule, FinTime)  :-
  retract( bestsofar( _, _)), !,
  assert( bestsofar( Schedule, FinTime)).

% List of tasks to be scheduled

tasks( [t1/4,t2/2,t3/2, t4/20, t5/20, t6/11, t7/11]).

% Precedence constraints

prec( t1, t4).   prec( t1, t5).   prec( t2, t4).   prec( t2, t5).
prec( t2, t6).   prec( t3, t5).   prec( t3, t6).   prec( t3, t7).

% resource( Task, Processors):
%   Any processor in Processors suitable for Task

resource( _, [1,2,3]).     % Three processors, all suitable for any task

