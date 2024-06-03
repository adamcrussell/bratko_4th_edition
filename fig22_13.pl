% Figure 22.13  A qualitative model of the block-spring system.


% Model of block on spring

landmarks( x, [ minf, zero, inf]).        % Position of block
landmarks( v, [ minf, zero, v0, inf]).    % Velocity of block
landmarks( a, [ minf, zero, inf]).        % Acceleration of block

correspond( x:zero, a:zero).

legalstate( [ X, V, A])  :-
  deriv( X, V),
  deriv( V, A),
  MinusA = a:_,
  sum( A, MinusA, a:zero/std),    % MinusA = -A
  mplus( X, MinusA).              % Spring pulling mass back

initial( [ x:zero/inc, v:v0/std, a:zero/dec]).
