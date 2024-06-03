% Figure 14.7  Two electrical circuits.


circuit_a( R1, R2, T21)  :-
  T2 = (0,_),                  % Terminal T2 at potential 0  
  battery( T1, T2, 10),        % Battery 10 V
  resistor( T11, T12, R1),
  resistor( T21, T22, R2),
  conn( [ T1, T11]),
  conn( [ T12, T21]),
  conn( [ T2, T22]).

circuit_b( U, T11, T21, T31, T41, T51, T52)  :-
  T2 = ( 0, _),                    % Terminal T2 at potential 0
  battery( T1, T2, U),
  resistor( T11, T12, 5),          % R1 = 5
  resistor( T21, T22, 10),         % R2 = 10
  resistor( T31, T32, 15),         % R3 = 15
  resistor( T41, T42, 10),         % R4 = 10
  resistor( T51, T52, 50),         % R5 = 50
  conn( [T1, T11,T21]),
  conn( [T12, T31, T51]),
  conn( [T22, T41, T52]),
  conn( [T2, T32, T42]).
