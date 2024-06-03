%  Figure 25.6  Two problem definitions for explanation-based generalization.

% For compatibility with some Prologs the following predicates
% are defined as dynamic:

:- dynamic gives/3, would_please/2, would_comfort/2, feels_sorry_for/2, 
   go/3, move/2, move_list/2.

% A domain theory: about gifts

gives( Person1, Person2, Gift)  :-
  likes( Person1, Person2),
  would_please( Gift, Person2).

gives( Person1, Person2, Gift)  :-
  feels_sorry_for( Person1, Person2),
  would_comfort( Gift, Person2).

would_please( Gift, Person)  :-
  needs( Person, Gift).

would_comfort( Gift, Person)  :-
  likes( Person, Gift).

feels_sorry_for( Person1, Person2)  :-
  likes( Person1, Person2),
  sad( Person2).

feels_sorry_for( Person, Person)  :-
  sad( Person).

% Operational predicates

operational( likes( _, _)).
operational( needs( _, _)).
operational( sad( _)).

% An example situation

likes( john, annie).
likes( annie, john).
likes( john, chocolate).
needs( annie, tennis_racket).
sad( john).

% Another domain theory: about lift movement

%  go( Level, GoalLevel, Moves)  if
%    list of moves Moves brings lift from Level to GoalLevel

go( Level, GoalLevel, Moves)  :-
  move_list( Moves, Distance),         % A move list and distance travelled
  Distance =:= GoalLevel - Level.

move_list( [], 0).

move_list( [Move1 | Moves], Distance + Distance1)  :-
  move_list( Moves, Distance),
  move( Move1, Distance1).

move( up, 1).
move( down, -1).

operational( A =:= B).

