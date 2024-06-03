% Figure 9.3  A more efficient implementation of quicksort using difference-pair
% representation for lists. Relation split( X, List, Small, Big) is as defined 
% Figure 9.2.


% quicksort( List, SortedList): sort List with the quicksort algorithm

quicksort( List, Sorted)  :-
  quicksort2( List, Sorted - [] ).

% quicksort2( List, SortedDiffList): sort List, result is represented as difference list

quicksort2( [], Z - Z).

quicksort2( [X | Tail], A1 - Z2)  :-
   split( X, Tail, Small, Big),
   quicksort2( Small, A1 - [X | A2] ),
   quicksort2( Big, A2 - Z2).
