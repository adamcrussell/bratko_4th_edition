% Figure 22.11  A qualitative model of the circuit in Figure 22.10.


%  Qualitative model of electric circuit with resistor and capacitors

landmarks( volt, [minf, zero, v0, inf]).   % Voltage on capacitors
landmarks( voltR, [minf, zero, v0, inf]).  % Voltage on resistor
landmarks( current, [minf, zero, inf]).

correspond( voltR:zero, current:zero).

legalstate( [ UC1, UC2, UR, CurrR])  :-
  sum( UR, UC2, UC1),
  mplus( UR, CurrR),                  % Ohm's law for resistor
  deriv( UC2, CurrR),
  sum( CurrR, current:CurrC1, current:zero/std),   % CurrC1 = - CurrR
  deriv( UC1, current:CurrC1).        % CurrC1 = d/dt UC1


initial( [ volt:v0/dec, volt:zero/inc, voltR:v0/dec, current:zero..inf/dec]).
