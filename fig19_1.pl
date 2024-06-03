% Figure 19.1  Scheduling with precedence constraints and no resource constraints

% Scheduling with CLP with unlimited resources

schedule( Schedule, FinTime)  :-
  tasks( TasksDurs),
  precedence_constr( TasksDurs, Schedule, FinTime),          	% Construct precedence constraints
  minimize( FinTime).

precedence_constr( [], [], FinTime).

precedence_constr( [T/D | TDs], [T/Start/D | Rest], FinTime)  :-
  { Start >= 0,                                           	% Earliest start at 0
    Start + D =< FinTime},                                     	% Must finish by FinTime
  precedence_constr( TDs, Rest, FinTime),      
  prec_constr( T/Start/D, Rest).

prec_constr( _, []).

prec_constr( T/S/D, [T1/S1/D1 | Rest])  :-
  (  prec( T, T1), !, { S+D =< S1}              % Case when task T precedes T1				
     ;
     prec( T1, T), !, { S1+D1 =< S}             % Case when task T1 precedes T
     ;
     true ),                                    % Case of no precedence constr. between T and T1
  prec_constr( T/S/D, Rest).

% List of tasks to be scheduled

tasks( [ t1/5, t2/7, t3/10, t4/2, t5/9]).

% Precedence constraints

prec( t1, t2).   prec( t1, t4).   prec( t2, t3).   prec( t4, t5).

