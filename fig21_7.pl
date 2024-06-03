% Figure 21.7  The HYPER program. The procedure prove/3 is as in Figure 21.3.

% Program HYPER (Hypothesis Refiner) for learning in logic

:-  op( 500, xfx, :).

% induce( Hyp):
%   induce a consistent and complete hypothesis Hyp by gradually
%   refining start hypotheses

induce( Hyp)  :-
  init_counts, !,              % Initialise counters of hypotheses
  start_hyps( Hyps),           % Get starting hypotheses
  best_search( Hyps, _:Hyp).   % Specialised best-first search

% best_search( CandidateHyps, FinalHypothesis)

best_search( [Hyp | Hyps], Hyp)  :-
  show_counts,           % Display counters of hypotheses
  Hyp = 0:H,             % cost = 0: H doesn't cover any neg. examples
  complete(H).           % H covers all positive examples

best_search( [C0:H0 | Hyps0], H)  :-
  write('Refining hypo with cost '), write( C0), 
  write(:), nl, show_hyp(H0), nl,
  all_refinements( H0, NewHs),           % All refinements of H0
  add_hyps( NewHs, Hyps0, Hyps), !,
  add1( refined),                           % Count refined hypos
  best_search( Hyps, H).

all_refinements( H0, Hyps)  :-
  findall( C:H, 
           ( refine_hyp(H0,H),              % H new hypothesis
             once(( add1( generated),       % Count generated hypos
                    complete(H),            % H covers all pos. exampl.
                    add1( complete),        % Count complete hypos
                    eval(H,C)               % C is cost of H
             )) ), 
           Hyps).

% add_hyps( Hyps1, Hyps2, Hyps):
%   merge Hyps1 and Hyps2 in order of costs, giving Hyps

add_hyps( Hyps1, Hyps2, Hyps)  :-
  mergesort( Hyps1, OrderedHyps1),
  merge( Hyps2, OrderedHyps1, Hyps).

complete( Hyp)  :-          % Hyp covers all positive examples
  \+ ( ex( P),                          % A positive example
       once( prove( P, Hyp, Answ)),     % Prove it with Hyp
       Answ \== yes).                   % Possibly not proved

% eval( Hypothesis, Cost):
%   Cost of Hypothesis = Size + 10 * # covered negative examples

eval( Hyp, Cost)  :-
  size( Hyp, S),                    % Size of hypothesis
  covers_neg( Hyp, N),              % Number of covered neg. examples
  ( N = 0, !, Cost is 0;            % No covered neg. examples
    Cost is S + 10*N).             

% size( Hyp, Size):
%   Size = k1*#literals + k2*#variables in hypothesis; 
%   Settings of parameters: k1=10, k2=1

size( [], 0).

size( [Cs0/Vs0 | RestHyp], Size)  :-
  length(Cs0, L0),
  length( Vs0, N0),
  size( RestHyp, SizeRest),  
  Size is 10*L0 + N0 + SizeRest.

% covers_neg( H, N):
%   N is number of neg. examples possibly covered by H
%   Example possibly covered if prove/3 returns 'yes' or 'maybe'

covers_neg( Hyp, N)  :-         % Hyp covers N negative examples
  findall( 1, (nex(E), once(prove(E,Hyp,Answ)), Answ \== no), L),
  length( L, N).

% unsatisfiable( Clause, Hyp):
%   Clause can never be used in any proof, that is:
%   Clause's body cannot be proved from Hyp

unsatisfiable( [Head | Body], Hyp)  :-
  once( prove( Body, Hyp, Answ)), Answ = no.
   
start_hyps( Hyps)  :-       	% Set of starting hypotheses
  max_clauses( M),
  setof( C:H, 
    (start_hyp(H,M), add1(generated), 
     complete(H), add1(complete), eval(H,C)), 
    Hyps).

% start_hyp( Hyp, MaxClauses):
%   A starting hypothesis with no more than MaxClauses

start_hyp( [], _).

start_hyp( [C | Cs], M)  :-
  M > 0, M1 is M-1,
  start_clause( C),          	% A user-defined start clause
  start_hyp( Cs, M1).

% refine_hyp( Hyp0, Hyp):
%   refine hypothesis Hyp0 into Hyp

refine_hyp( Hyp0, Hyp)  :-
  choose_clause( Hyp0, Clause0/Vars0, Clauses1, Clauses2), % Choose a clause
  conc( Clauses1, [Clause/Vars | Clauses2], Hyp),          % New hypothesis
  refine( Clause0, Vars0, Clause, Vars),                   % Refine chosen clause  
  non_redundant( Clause),                            % No redundancy in Clause 
  \+ unsatisfiable( Clause, Hyp).                    % Clause not unsatisfiable

choose_clause( Hyp, Clause, Clauses1, Clauses2)  :-  % Choose Clause from Hyp
    conc( Clauses1, [Clause | Clauses2], Hyp),       % Choose a clause
    nex(E),                                          % A negative example E
    prove( E, [Clause], yes),                        % Clause itself covers E
    !                                                % Clause must be refined 
    ;  
    conc( Clauses1, [Clause | Clauses2], Hyp).       % Otherwise choose any clause  

% refine( Clause, Args, NewClause, NewArgs):
%   refine Clause with variables Args giving NewClause with NewArgs

% Refine by unifying arguments 

refine( Clause, Args, Clause, NewArgs)  :-
  conc( Args1, [A | Args2], Args),               % Select a variable A
  member( A, Args2),                             % Match it with another one
  conc( Args1, Args2, NewArgs).


% Refine a variable to a term

refine( Clause, Args0, Clause, Args)  :-
  del( Var:Type, Args0, Args1),       % Delete Var:Type from Args0
  term( Type, Var, Vars),             % Var becomes term of type Type 
  conc( Args1, Vars, Args).           % Add variables in the new term

% Refine by adding a literal

refine( Clause, Args, NewClause, NewArgs)  :-
  length( Clause, L),
  max_clause_length( MaxL),
  L < MaxL,
  backliteral( Lit, InArgs, RestArgs),   % Background knowledge literal
  conc( Clause, [Lit], NewClause),       % Add literal to body of clause
  connect_inputs( Args, InArgs),         % Connect literal's inputs to other args.
  conc( Args, RestArgs, NewArgs).        % Add rest of literal's arguments

% non_redundant( Clause): Clause has no obviously redundant literals

non_redundant( [_]).                % Single literal clause

non_redundant( [Lit1 | Lits])  :-
  \+ literal_member( Lit1, Lits),
  non_redundant( Lits).

literal_member( X, [X1 | Xs])  :-   % X literally equal to member of list
  X == X1, !
  ;
  literal_member( X, Xs).
  
% show_hyp( Hypothesis):
%   Write out Hypothesis in readable form with variables names A, B, ...

show_hyp( [])  :-  nl.

show_hyp( [C/Vars | Cs])  :- nl,
  copy_term( C/Vars, C1/Vars1),
  name_vars( Vars1, ['A','B','C','D','E','F','G','H','I','J','K','L','M','N']),
  show_clause( C1), 
  show_hyp( Cs), !.

show_clause( [Head | Body])  :- 
  write( Head), 
  ( Body = []; write( ':-' ), nl ), 
  write_body( Body). 

write_body( [])  :-
  write('.'), !.

write_body( [G | Gs])  :-  !,
  tab( 2), write( G), 
  ( Gs = [], !, write('.'), nl
    ;
    write(','), nl,
    write_body( Gs)
  ).

name_vars( [], _).

name_vars( [Name:Type | Xs], [Name | Names])  :-
  name_vars( Xs, Names).

% connect_inputs( Vars, Inputs):
%   Match each variable in list Outputs with a variable in list Vars

connect_inputs( _, []).

connect_inputs( S, [X | Xs])  :-
  member( X, S),
  connect_inputs( S, Xs).

% merge( L1, L2, L3), all lists sorted

merge( [], L, L)  :- !.

merge( L, [], L)  :- !.

merge( [X1|L1], [X2|L2], [X1|L3])  :-
  X1 @=< X2, !,              % X1 "lexicographically precedes" X2 (built-in predicate)
  merge( L1, [X2|L2], L3).

merge( L1, [X2|L2], [X2|L3])  :-
  merge( L1, L2, L3).

% mergesort( L1, L2): sort L1 giving L2

mergesort( [], []) :- !.

mergesort( [X], [X]) :- !.

mergesort( L, S)  :-
  split( L, L1, L2),
  mergesort( L1, S1),
  mergesort( L2, S2),
  merge( S1, S2, S).

% split( L, L1, L2): split L into lists of approx. equal length

split( [], [], []).

split( [X], [X], []).

split( [X1,X2 | L], [X1|L1], [X2|L2])  :-
  split( L, L1, L2).

% Counters of generated, complete and refined hypotheses

init_counts :-
  retract( counter(_,_)), fail        % Delete old counters
  ;
  assert( counter( generated, 0)),    % Init. counter 'generated'
  assert( counter( complete, 0)),     % Init. counter 'complete'
  assert( counter( refined, 0)).      % Init. counter 'refined'

add1( Counter)  :-
  retract( counter( Counter, N)), !, N1 is N+1,
  assert( counter( Counter, N1)).

show_counts :-
  counter(generated, NG), counter( refined, NR), counter( complete, NC),
  nl, write( 'Hypotheses generated: '), write(NG), 
  nl, write( 'Hypotheses refined:   '), write(NR),
  ToBeRefined is NC - NR,
  nl, write( 'To be refined:        '), write( ToBeRefined), nl.

% Parameter settings

max_proof_length( 6).   % Max. proof length, counting calls to preds. in hypothesis
max_clauses( 4).        % Max. number of clauses in hypothesis
max_clause_length( 5).  % Max. number of literals in a clause
