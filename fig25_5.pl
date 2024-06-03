% Figure 25.5:  Prolog meta-interpreter with query-the-user facility

% prove_qu( Goal): 
%    Goal logically follows from the program and user's answers

prove_qu( true)  :-  !.

prove_qu( ( Goal1, Goal2))  :-  !,
  prove_qu( Goal1),	
  prove_qu( Goal2).	


prove_qu( Goal)  :-
   prolog( Goal), !,				% User-declared as "Prolog goal"
   Goal.					% Prove this goal by original Prolog interpreter

prove_qu( Goal)  :-
  clause( Goal, Body),
  prove_qu( Body).				% Body can be proved if Answers0 is extended to Answers
  
prove_qu( Goal)  :-	
  askable( Goal),				% Goal may be asked of the user
  user_answer( 1, Goal).            		% Now query the user

%  user_answer( N, Goal):
%    retrieve previous user's answers about Goal, indexed N or higher
%    then ask user for further solutions of Goal, assert answers

user_answer( N, Goal)  :-			% Retrieve user's answers about Goal indexed N or higher
   last_index( Last),
   N =< Last,
   (  was_told( N, Goal)			% Answer indexed N
      ;
      N1 is N+1,
      user_answer( N1, Goal)
   ).

user_answer( _, Goal)  :- 
   \+ (numbervars( Goal, 1, _),   		% Freeze variables in Goal
       end_answers( Goal)),			% Further solutions of Goal possible
   ask_user( Goal),				% Ask user about Goal
   read( Answer),
   ( Answer = no, !,				% User says no (further) solution
     asserta( end_answers( Goal)), fail		% Make sure to never ask about Goal again
     ;
     copy_term( Goal, GoalCopy),
     Answer = GoalCopy,  
     next_index( I),				% Index for next answer to be asserted
     assertz( was_told( I, Answer)),		% New fact about Goal, assert it
     user_answer( I, Goal)			% More facts about Goal?
   ).

ask_user( Goal)  :-
   nl, write( 'Known facts about '), write( Goal), write( :), nl,
   ( \+ was_told( _, Goal), write('    None so far'), nl, !; true),
   ( was_told( _, Goal), write('    '), write( Goal), nl, fail; true),	% Display all known solutions
   nl, write( 'Any (other) solution?'), nl,
   write( 'Answer with ''no'' or instantiated goal '),
   write( Goal), nl.

next_index( I)  :-
   retract( last_index( Last)), !,
   I is Last + 1,
   asserta( last_index( I)).

:-  dynamic last_index/1, was_told/2, end_answers/1.

last_index( 0).	% Initialise index

% An example domain: finding chains of supervisors

:-  dynamic supervisor_chain/3, chain/3, supervised/2.

askable( supervised( Person1, Person2)).

prolog( conc( L1, L2, L3)).		% conc/3 to be executed by original Prolog interpreter
prolog( length( L, N)).			% length/2 to be executed by original Prolog

% Shortest supervisor-to-student chain between persons P1 and P2;
 
supervisor_chain( P1, P2, Chain)  :-	% P1 supervised P2 directly, or "indirectly" through P1's student
   length( MaxChain, 10),		% Longest allowed chain length is 10
   conc( Chain, _, MaxChain),		% Generate lists - shortest first
   chain( P1, P2, Chain).

chain( P, P, [ P]).

chain( P0, P, [P0, P1 | Chain])  :-	
   supervised( P0, P1),		% P0 supervised P1
   chain( P1, P, [P1 | Chain]).
