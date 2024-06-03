% Figure 21.3  A loop-avoiding interpreter for hypotheses.


% Interpreter for hypotheses
% prove( Goal, Hypo, Answ):
%   Answ = yes, if Goal derivable from Hypo in at most D steps
%   Answ = no, if Goal not derivable
%   Answ = maybe, if search terminated after D steps inconclusively

prove( Goal, Hypo, Answer)  :-
  max_proof_length( D),
  prove( Goal, Hypo, D, RestD), 
  (RestD >= 0, Answer = yes          % Proved
   ;
   RestD < 0, !, Answer = maybe      % Maybe, but it looks like inf. loop
  ).
  
prove( Goal, _, no).       % Otherwise Goal definitely cannot be proved

% prove( Goal, Hyp, MaxD, RestD):
%   MaxD allowed proof length, RestD 'remaining length' after proof;
%   Count only proof steps using Hyp

prove( G, H, D, D)  :-
  D < 0, !.                % Proof length overstepped

prove( [], _, D, D)  :-  !.

prove( [G1 | Gs], Hypo, D0, D)  :-  !,
  prove( G1, Hypo, D0, D1), 
  prove( Gs, Hypo, D1, D).

prove( G, _, D, D)  :-
  prolog_predicate( G),               % Background predicate in Prolog?
  call( G).                           % Call of background predicate

prove( G, Hyp, D0, D)  :-
  D0 =< 0, !, D is D0-1               % Proof too long
  ;
  D1 is D0-1,                         % Remaining proof length
  member( Clause/Vars, Hyp),          % A clause in Hyp
  copy_term( Clause, [Head | Body] ), % Rename variables in clause
  G = Head,                           % Match clause's head with goal
  prove( Body, Hyp, D1, D).           % Prove G using Clause
