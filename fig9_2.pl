% Figure 9.2  Quicksort.


% quicksort( List, SortedList): sort List by the quicksort algorithm

quicksort( [], []).

quicksort( [X|Tail], Sorted)  :-
   split( X, Tail, Small, Big),
   quicksort( Small, SortedSmall),
   quicksort( Big, SortedBig),
   conc( SortedSmall, [X|SortedBig], Sorted).

split( X, [], [], []).

split( X, [Y|Tail], [Y|Small], Big)  :-
   gt( X, Y), !,
   split( X, Tail, Small, Big).

split( X, [Y|Tail], Small, [Y|Big])  :-
   split( X, Tail, Small, Big).
