% Figure 6.4   An implementation of the findall relation.


findall( X, Goal, Xlist)  :-
  call( Goal),                         % Find a solution
  assertz( queue(X) ),                 % Assert it
  fail;                                % Try to find more solutions
  assertz( queue(bottom) ),            % Mark end of solutions
  collect( Xlist).                     % Collect the solutions 

collect( L)  :-
  retract( queue(X) ), !,              % Retract next solution
  ( X == bottom, !, L = []             % End of solutions?
    ;
    L = [X | Rest], collect( Rest) ).  % Otherwise collect the rest 
