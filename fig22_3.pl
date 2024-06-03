% Figure 22.3  Qualitative modelling program for simple circuits. 


%  Modelling simple electric circuits
%  Qualitative values of voltages and currents are: neg, zero, pos

%  Definition of switch
%  switch( SwitchPosition, Voltage, Current)

switch( on, zero, AnyCurrent).      % Switch on: zero voltage
switch( off, AnyVoltage, zero).     % Switch off: zero current

%  Definition of bulb
%  bulb( BulbState, Lightness, Voltage, Current)

bulb( blown, dark, AnyVoltage, zero).  
bulb( ok, light, pos, pos).
bulb( ok, light, neg, neg).
bulb( ok, dark, zero, zero).

%  A simple circuit consisting of a bulb, switch and battery

circuit1( SwitchPos, BulbState, Lightness)  :-
   switch( SwitchPos, SwVolt, Curr),
   bulb( BulbState, Lightness, BulbVolt, Curr),
   qsum( SwVolt, BulbVolt, pos).     % Battery voltage = pos

%  A more interesting circuit made of a battery, three bulbs and 
%  three switches

circuit2( Sw1, Sw2, Sw3, B1, B2, B3, L1, L2, L3)  :-
   switch( Sw1, VSw1, C1),
   bulb( B1, L1, VB1, C1),
   switch( Sw2, VSw2, C2),
   bulb( B2, L2, VB2, C2),
   qsum( VSw2, VB2, V3),
   switch( Sw3, V3, CSw3),
   bulb( B3, L3, V3, CB3),
   qsum( VSw1, VB1, V1),
   qsum( V1, V3, pos),
   qsum( CSw3, CB3, C3),
   qsum( C2, C3, C1).   
   
%  qsum( Q1, Q2, Q3):
%    Q3 = Q1 + Q2, qualitative sum over domain [pos,zero,neg]

qsum( pos, pos, pos).
qsum( pos, zero, pos).
qsum( pos, neg, pos).
qsum( pos, neg, zero).
qsum( pos, neg, neg).
qsum( zero, pos, pos).
qsum( zero, zero, zero).
qsum( zero, neg, neg).
qsum( neg, pos, pos).
qsum( neg, pos, zero).
qsum( neg, pos, neg). 
qsum( neg, zero, neg).
qsum( neg, neg, neg).
