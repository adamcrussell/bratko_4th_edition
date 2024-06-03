% Figure 15.9   Interactive expert system shell with how and why explanation.

% Interaction with user and why and how explanation

:-  op( 800, fx, if).
:-  op( 700, xfx, then).
:-  op( 300, xfy, or).
:-  op( 200, xfy, and).
:-  op( 800, xfx, <=).

% is_true( P, Proof): Proof is a proof that P is true

is_true( P, Proof)  :-
   explore( P, Proof, []).

%  explore( P, Proof, Trace):
%     Proof is an explanation for P, Trace is a chain of rules between P's ancestor goals

explore( P, P, _)  :-
   fact( P).						%  P is a fact

explore( P1 and P2, Proof1 and Proof2, Trace)  :-  !,
   explore( P1, Proof1, Trace),
   explore( P2, Proof2, Trace).

explore( P1 or P2, Proof, Trace)  :-  !,
   (
      explore( P1, Proof, Trace)
      ;
      explore( P2, Proof, Trace)
   ).

explore( P, P <= CondProof, Trace)  :-
   if Cond then P,					%  A rule relevant to P 
   explore( Cond, CondProof, [ if Cond then P | Trace]).

explore( P, Proof, Trace)  :-
   askable( P),						% P may be asked of user
   \+ fact( P),						% P not already known fact
   \+ already_asked( P),				% P not yet asked of user
   ask_user( P, Proof, Trace).

ask_user( P, Proof, Trace)  :-
   nl, write( 'Is it true:'), write( P), write(?), nl, write( 'Please answer yes, no, or why'), nl,
   read( Answer),
   process_answer( Answer, P, Proof, Trace).		% Process user's answer
   
process_answer( yes, P, P  <= was_told, _)  :-		% User told P is true
   asserta( fact(P)),
   asserta( already_asked( P)).

process_answer( no, P, _, _)  :-
   asserta( already_asked( P)),				% Make sure not to ask again about P
   fail.						% User told P is not true

process_answer( why, P, Proof, Trace)  :-		% User requested why-explanation
   display_rule_chain( Trace, 0), nl,
   ask_user( P, Proof, Trace).				% Ask about P again
   
display_rule_chain( [], _).

display_rule_chain( [if C then P | Rules], Indent)  :-
   nl, tab( Indent), write( 'To explore whether '), write( P), write(' is true, using rule:'), 
   nl, tab( Indent), write( if C then P),
   NextIndent is Indent + 2,
   display_rule_chain(  Rules, NextIndent).

:- dynamic already_asked/1.
