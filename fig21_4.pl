% Figure  21.4  MINIHYPER - a simple ILP program.


% Program MINIHYPER

% induce( Hyp):
%   induce a consistent and complete hypothesis Hyp by gradually
%   refining start hypotheses

induce( Hyp)  :-
  iter_deep( Hyp, 0).           % Iterative deepening starting with max. depth 0

iter_deep( Hyp, MaxD) :-
  write( 'MaxD = '), write( MaxD), nl,
  start_hyp( Hyp0),
  complete( Hyp0),                  % Hyp0 covers all positive examples
  depth_first( Hyp0, Hyp, MaxD)     % Depth-limited depth-first search
  ;
  NewMaxD is MaxD + 1,
  iter_deep( Hyp, NewMaxD).

% depth_first( Hyp0, Hyp, MaxD):
%   refine Hyp0 into consistent and complete Hyp in at most MaxD steps

depth_first( Hyp, Hyp, _)  :-
  consistent( Hyp).

depth_first( Hyp0, Hyp, MaxD0)  :-
  MaxD0 > 0,
  MaxD1 is MaxD0 - 1,
  refine_hyp( Hyp0, Hyp1),
  complete( Hyp1),                % Hyp1 covers all positive examples
  depth_first( Hyp1, Hyp, MaxD1).

complete( Hyp)  :-        % Hyp covers all positive examples
  \+ (ex( E),                          % A positive example
       once( prove( E, Hyp, Answer)),   % Prove it with Hyp
       Answer \== yes).                 % Possibly not proved

consistent( Hyp)  :-      % Hypothesis does not possibly cover any negative example
  \+ (nex( E),                          % A negative example
       once( prove( E, Hyp, Answer)),    % Prove it with Hyp
       Answer \== no).                   % Possibly provable

% refine_hyp( Hyp0, Hyp):
%   refine hypothesis Hyp0 into Hyp

refine_hyp( Hyp0, Hyp)  :-
  conc( Clauses1, [Clause0/Vars0 | Clauses2], Hyp0),    % Choose Clause0 from Hyp0
  conc( Clauses1, [Clause/Vars | Clauses2], Hyp),       % New hypothesis
  refine( Clause0, Vars0, Clause, Vars).                % Refine the Clause  

% refine( Clause, Args, NewClause, NewArgs):
%   refine Clause with arguments Args giving NewClause with NewArgs

% Refine by unifying arguments

refine( Clause, Args, Clause, NewArgs)  :-
  conc( Args1, [A | Args2], Args),               % Select a variable A
  member( A, Args2),                             % Match it with another one
  conc( Args1, Args2, NewArgs).

% Refine by adding a literal

refine( Clause, Args, NewClause, NewArgs)  :-
  length( Clause, L),
  max_clause_length( MaxL),
  L < MaxL,
  backliteral( Lit, Vars),                    % Background knowledge literal
  conc( Clause, [Lit], NewClause),            % Add literal to body of clause
  conc( Args, Vars, NewArgs).                 % Add literal's variables

% Default parameter settings

max_proof_length( 6).   % Max. proof length, counting calls to 'non-prolog' pred.

max_clause_length( 3).  % Max. number of literals in a clause
