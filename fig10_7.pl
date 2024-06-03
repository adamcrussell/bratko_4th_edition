%  Figure  10.7  A program to display a 2-3 dictionary.


% Displaying 2-3 dictionary

show(T)  :-
   show(T,0).

show( nil, _).

show(l(A),H)  :-
   tab(H), write(A), nl.

show( n2( T1, M, T2), H)  :-
   H1 is H+5,
   show( T2, H1),
   tab(H), write(--), nl,
   tab(H), write(M), nl,
   tab(H), write(--), nl,
   show( T1, H1).

show( n3( T1, M2, T2, M3, T3), H)  :-
   H1 is H+5,
   show( T3, H1),
   tab(H), write(--), nl,
   tab(H), write(M3), nl,
   show( T2, H1),
   tab(H), write(M2), nl,
   tab(H), write(--), nl,
   show( T1, H1).
