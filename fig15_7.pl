% Figure 15.7  A forward chaining rule interpreter.


% Simple forward chaining in Prolog

:-  op( 800, fx, if).
:-  op( 700, xfx, then).
:-  op( 300, xfy, or).
:-  op( 200, xfy, and).

forward  :-
   new_derived_fact( P),             % A new fact   
   !,
   write( 'Derived: '), write( P), nl,
   assert( fact( P)),
   forward                           % Continue   
   ;
   write( 'No more facts').          % All facts derived

new_derived_fact( Concl)  :-
   if Cond then Concl,               % A rule   
   not fact( Concl),                 % Rule's conclusion not yet a fact
   composed_fact( Cond).             % Condition true? 

composed_fact( Cond)  :-
   fact( Cond).                      % Simple fact 

composed_fact( Cond1 and Cond2)  :-
   composed_fact( Cond1),
   composed_fact( Cond2).            % Both conjuncts true 

composed_fact( Cond1 or Cond2)  :-
   composed_fact( Cond1)
   ;
   composed_fact( Cond2).
