% Figure 25.4: Abductive reasoning implemented as Prolog meta-interpreter


% Abductive reasoning as an abductive Prolog meta-interpreter

% abduce( Goal, Delta): 
%    Delta is a list of abduced literals when proving Goal
%    Goal logically follows from the program under the assumption that Delta is true

abduce( Goal, Delta)  :-
  abduce( Goal, [], Delta, 0, _).

% abduce( Goal, Delta0, Delta, N0, N):
%   Delta0 is "accumulator" variable with Delta as its final value
%   N0 is next "free index" for "numbering variables" in abduced goals, N is final free index

abduce( true, Delta, Delta, N, N)  :-  !.

abduce( ( Goal1, Goal2), Delta0, Delta, N0, N)  :-  !,
  abduce( Goal1, Delta0, Delta1, N0, N1),	% Prove Goal1 by extending Delta0 to Delta1
  abduce( Goal2, Delta1, Delta, N1, N).		% Prove Goal2 by extending Delta1 to Delta

abduce( Goal, Delta0, Delta, N0, N)  :-
  clause( Goal, Body),
  abduce( Body, Delta0, Delta, N0, N).		% Prove Body by extending Delta0 to Delta
  
% Abduction reasoning steps:

abduce( Goal, Delta, Delta, N, N)  :-
  member( Goal, Delta).            		% Goal already abduced

abduce( Goal, Delta, [Goal | Delta], N0, N)  :-
  abducible( Goal),  				% Goal is abducible
  numbervars( Goal, N0, N). 			% Replace variables in Goal by Skolem constants


% An example domain: diagnosing faults in lights

:-  dynamic not_working/1, no_current/1, switch/1, fuse/1.

not_working( Light)  :-
   bulb_in( Light, Bulb),			% Bulb inside Light
   blown( Bulb).

not_working( Device)  :-
   no_current( Device).				% No electric current in the device

no_current( Device)  :-				% No electrice current in Device
   switch( Switch),
   connected( Device, Switch),
   broken( Switch).				% Switch of Device is broken

no_current( Device)  :-
   fuse( Fuse),
   connected( Device, Fuse),
   melted( Fuse).

switch( switch1).
switch( switch2).
fuse( fuse1).

abducible( broken( Switch)).
abducible( melted( Fuse)).
abducible( blown( Bulb)).
abducible( bulb_in( Light, Bulb)).
abducible( connected( Device, SwitchOrFuse)).





