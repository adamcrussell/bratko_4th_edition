% Figure 25.1  The basic Prolog meta-interpreter.


% The basic Prolog meta-interpreter

prove( true).

prove( ( Goal1, Goal2))  :-
  prove( Goal1),
  prove( Goal2).

prove( Goal)  :-
  clause( Goal, Body),
  prove( Body).
