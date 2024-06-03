%  Figure 25.15  Translating a propositional calculus formula into
%  a set of (asserted) clauses.


%  Translating a propositional formula into (asserted) clauses

:-  op( 100, fy, ~).        % Negation
:-  op( 110, xfy, &).       % Conjunction
:-  op( 120, xfy, v).       % Disjunction
:-  op( 130, xfy, =>).      % Implication

% translate( Formula): translate propositional Formula
%   into clauses and assert each resulting clause C as clause( C)

translate( F & G)  :-                    % Translate conjunctive formula
  !,                                     % Red cut
  translate( F),
  translate( G).

translate( Formula)  :-
  transform( Formula, NewFormula),       % Transformation step on Formula
  !,                                     % Red cut
  translate( NewFormula).

translate( Formula)  :-                  % No more transformation possible
  assert( clause( Formula)).

% Transformation rules for propositional formulas

% transform( Formula1, Formula2)  if
%   Formula2 is equivalent to Formula1, but closer to clause form

transform( ~(~X), X).                      % Eliminate double negation

transform( X => Y, ~X v Y).                % Eliminate implication

transform( ~ (X & Y), ~X v ~Y).            % De Morgan's law

transform( ~ (X v Y), ~X & ~Y).            % De Morgan's law

transform( X & Y v Z, (X v Z) & (Y v Z)).  % Distribution

transform( X v Y & Z, (X v Y) & (X v Z)).  % Distribution

transform( X v Y, X1 v Y)  :-
  transform( X, X1).                       % Transform subexpression

transform( X v Y, X v Y1)  :-
  transform( Y, Y1).                       % Transform subexpression

transform( ~ X, ~ X1)  :-              
  transform( X, X1).                       % Transform subexpression
