% Figure 4.4: Task planning 

% State of the robot’s world = state( RobotLocation, BasketLocation, RubbishLocation)
% action( State, Action, NewState): Action in State produces NewState
% We assume robot never drops rubbish to floor, and never pushes rubbish around

action( state( Pos1, Pos2, floor(Pos1)), 	% Robot and rubbish both at Pos1
        pickup, 				% Pick up rubbish from floor
        state( Pos1, Pos2, held)).   		% Rubbish now held by robot
                                         
action( state( Pos, Pos, held), 		% Robot and basket both at Pos
        drop, 					% Drop rubbish to basket
        state( Pos, Pos, in_basket)).     	% Rubbish now in basket                               

action( state( Pos, Pos, Loc), 			% Robot and basket both at Pos
        push( Pos, NewPos), 			% Push basket from Pos to NewPos
        state( NewPos, NewPos, Loc)).	% Robot and basket now at NewPos

action( state( Pos1, Pos2, Loc), 
        go( Pos1, NewPos1), 			% Go from Pos1 to NewPos1
        state( NewPos1, Pos2, Loc)).

% plan( StartState, FinalState, Plan)

plan( State, State, [ ]).			% To achieve State from State itself, do nothing

plan( State1, GoalState, [ Action1 | RestOfPlan])  :-
  action( State1, Action1, State2),             % Make first action resulting in State2
  plan( State2, GoalState, RestOfPlan).		% Find rest of plan
