% Figure 19.4: Constraints for some electrical components and connections.

% Electric circuit simulator in CLP(R)

% resistor( T1, T2, R):
%  R=resistance; T1, T2 its terminals

resistor( (V1,I1), (V2,I2), R)  :-
  { I1 = -I2, V1-V2 = I1*R }.

% diode( T1, T2):
%   T1, T2 terminals of a diode
%   Diode open in direction from T1 to T2

diode( (V1,I1), (V2,I2) )  :-
  { I1 + I2 = 0},
  { I1 > 0, V1 = V2                  % Diode open
    ;
    I1 = 0, V1 =< V2}.               % Diode closed

battery( (V1,I1), (V2,I2), Voltage)  :-
  { I1 + I2 = 0, Voltage = V1 - V2 }.

% conn( [T1,T2,...]):
%  Terminals T1, T2, ... connected
%  Therefore all el.electrical potentials are equal, and sum of currents = 0

conn( Terminals)  :-
  conn( Terminals, 0).

conn( [ (V,I) ], Sum)  :-
  { Sum + I = 0 }.

conn( [ (V1,I1), (V2,I2) | Rest], Sum)  :-
  { V1 = V2, Sum1 = Sum + I1},
  conn( [ (V2, I2) | Rest], Sum1).


 
