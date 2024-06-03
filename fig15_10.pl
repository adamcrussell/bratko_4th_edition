% Figure 15.9  An interpreter for rules with certainties.

% Rule interpreter with certainties

:-  op( 800, fx, if).
:-  op( 700, xfx, then).
:-  op( 300, xfy, or).
:-  op( 200, xfy, and).

% certainty( Proposition, Certainty)

certainty( P, Cert)  :-
   given( P, Cert).

certainty( Cond1 and Cond2, Cert)  :-
   certainty( Cond1, Cert1),
   certainty( Cond2, Cert2),
   min( Cert1, Cert2, Cert).

certainty( Cond1 or Cond2, Cert)  :-
   certainty( Cond1, Cert1),
   certainty( Cond2, Cert2),
   max( Cert1, Cert2, Cert).

certainty( P, Cert)  :-
   if Cond then P : C1,
   certainty( Cond, C2),
   Cert is C1 * C2.
