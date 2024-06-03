%  Figure 15.6   A backward chaining interpreter for if-then rules.


% A simple backward chaining rule interpreter

:-  op( 800, fx, if).
:-  op( 700, xfx, then).
:-  op( 300, xfy, or).
:-  op( 200, xfy, and).

is_true( P)  :-
   fact( P).

is_true( P)  :-
   if Condition then P,        % A relevant rule   
   is_true( Condition).        % whose condition is true 

is_true( P1 and P2)  :-
   is_true( P1),
   is_true( P2).

is_true( P1 or P2)  :-
   is_true( P1)
   ;
   is_true( P2).
