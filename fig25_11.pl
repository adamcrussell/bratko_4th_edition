%  Figure 25.11:  A pattern-directed program to find the greatest 
%  common divisor of a set of numbers.

%  The follwing directive is required by some Prologs:

:-  dynamic num/1.

%  Production rules for finding greatest common divisor (Euclid algorithm)

:-  op( 800, xfx, --->).
:-  op( 300, fx, num).

[ num X, num Y, X > Y ]  --->
[ NewX is X - Y, replace( num X, num NewX) ].

[ num X]  --->  [ write( X), stop ].


%  An initial database

num 25.
num 10.   
num 15.   
num 30.
