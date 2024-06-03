% Figure 22.9  A qualitative model of bath tub.


% A bath tub model 

landmarks( amount, [ zero, full, inf]).
landmarks( level, [ zero, top, inf]).
landmarks( flow, [ minf, zero, inflow, inf]).

correspond( amount:zero, level:zero).
correspond( amount:full, level:top).

legalstate( [ Level, Amount, Outflow, Netflow])  :-
  mplus( Amount, Level),
  mplus( Level, Outflow),
  Inflow = flow:inflow/std,           % Constant in-flow
  sum( Outflow, Netflow, Inflow),     % Netflow = Inflow - Outflow
  deriv( Amount, Netflow),
  \+ overflowing( Level).            % Water not over the top

overflowing( level:top..inf/_).       % Over the top

initial( [ level: zero/inc,
           amount: zero/inc, 
           flow: zero/inc,
           flow: inflow/dec ] ).
