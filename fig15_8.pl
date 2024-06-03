% Figure 15.8  Generating proof trees as 'how' explanation.

% is_true( P, Proof) Proof is a proof that P is true

:-  op( 800, fx, if).
:-  op( 700, xfx, then).
:-  op( 300, xfy, or).
:-  op( 200, xfy, and).
:-  op( 800, xfx, <=).

is_true( P, P)  :-
   fact( P).

is_true( P, P <= CondProof)  :-
   if Cond then P,
   is_true( Cond, CondProof).

is_true( P1 and P2, Proof1 and Proof2)  :-
   is_true( P1, Proof1),
   is_true( P2, Proof2).

is_true( P1 or P2, Proof)  :-
   is_true( P1, Proof)
   ;
   is_true( P2, Proof).
