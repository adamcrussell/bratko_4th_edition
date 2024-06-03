%  Figure  19.7  A simulator for dynamic systems with a model of spring-and-mass system 
%  including external control force, with which it is possible to control the system.
 

%  simulate( InitialState, Behaviour):
%     Starting with InitialState, simulation produces Behaviour
%     Behaviour is a sequence of system's states until end of simulation
%     Time is included as part of the system's state

simulate( State, [State])  :-
    stop( State).                         % User-defined stopping criterion

simulate( State, [State | Rest])  :-  
   transition( State, NextState),         % Transition to next state, defined by system model
   simulate( NextState, Rest).

% Spring and block system model with control force applied to the block
% This model assumes that spring coefficient K = 1, and mass = 1
%  System's state variables are X (position of mass), V (velocity of mass)
%  X = 0 when the spring is at rest position (exerts no force on mass)
%   Also included as part of the state are time T and external force F

transition( [ T1, X1, V1, F1], [ T2, X2, V2, F2])  :-
   control( [T1,X1,V1,F1]),                % Impose constraints on control force F	
   time_step( DT),
   { T2 = T1 + DT,                         % Next time point
      A = F1 - (X1 + X2)/2,                % Approx. average acceleration in interval X1..X2
      V2 = V1+A*DT,                        % Velocity increases due to acceleration A
      X2 = X1 + (V1+V2)/2*DT}.             % X change due to average velocity in interval
   
time_step( 0.1).                           % Simulation time step

state0( [0.0, 0.0, 0.0, _]).               % State at time 0, with X= 01, V=0

stop( [ T, X, V, F])  :-
   { X >= 3.0},                            % Stop when X reaches 3
   maximize(X)                             % Find control to maximise X at this point
   ;
   { T > 20}.                              % Alternatively, give up at time 20

% Control rule that determines constraints on control force

control( [ _, _, _, F])  :-
   { -1.0 =< F, F =< 1.0}.                 % Control with limited force: choose force in interval -1..1

% show_behaviour( Behaviour):  write Behaviour in tabular form, one row per time point

show_behaviour( []).

show_behaviour( [S | L])  :-
  show_state(S), 
  show_behaviour( L).

show_state( [ ])  :-
  nl.

show_state( [X | Xs])  :-  !,
  round3( X, Xr),                           % Round X to 3 decimals
  write( Xr), write( '\t'),                 % Write Xr and move to next tab position
  show_state( Xs).

round3( X, Y)  :-                           % Y is X rounded to 3 decimal digits after the decimal point
   number(X), !, 
   Y is round(1000*X)/1000
   ;
   Y = X.                                   % Here X is not a number

