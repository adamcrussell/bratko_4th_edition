%  Figure 25.7  Explanation-based generalization.


%   ebg( Goal, GeneralizedGoal, SufficientCondition):
%     SufficientCondition in terms of operational predicates
%     guarantees that generalization of Goal, GeneralizedGoal, is true.
%     GeneralizedGoal must not be a variable

ebg( true, true, true)  :-  !.

ebg( Goal, GenGoal, GenGoal)  :-
  operational( GenGoal), 
  call( Goal).

ebg( (Goal1,Goal2), (Gen1,Gen2), Cond)  :- !,
  ebg( Goal1, Gen1, Cond1),
  ebg( Goal2, Gen2, Cond2),
  and( Cond1, Cond2, Cond).     % Cond = (Cond1,Cond2) simplified

ebg( Goal, GenGoal, Cond)  :-
  not operational( Goal),
  clause( GenGoal, GenBody),
  copy_term( (GenGoal,GenBody), (Goal,Body)),    % Fresh copy of (GenGoal,GenBody)
  ebg( Body, GenBody, Cond).

% and( Cond1, Cond2, Cond) if
%  Cond is (possibly simplified) conjunction of Cond1 and Cond2

and( true, Cond, Cond)  :-  !.        % (true and Cond) <==> Cond

and( Cond, true, Cond)  :-  !.        % (Cond and true) <==> Cond

and( Cond1, Cond2, ( Cond1, Cond2)).  
