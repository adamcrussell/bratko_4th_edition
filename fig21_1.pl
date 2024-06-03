% Figure 21.1  A definition of the problem of learning predicate has_daughter.


% Learning from family relations

% Background knowledge

backliteral( parent(X,Y),  [X,Y]).  % A background literal with vars. [X,Y]

backliteral( male(X), [X]).

backliteral( female(X), [X]).

prolog_predicate( parent(_,_)).     % Goal parent(_,_) executed directly by Prolog
prolog_predicate( male(_)).
prolog_predicate( female(_)).

parent( pam, bob).
parent( tom, bob).
parent( tom, liz).
parent( bob, ann).
parent( bob, pat).
parent( pat, jim).
parent( pat, eve).

female( pam).
male( tom).
male( bob).
female( liz).
female( ann).
female( pat).
male( jim).
female( eve).

% Positive examples

ex( has_daughter(tom)).       % Tom has a daughter
ex( has_daughter(bob)).
ex( has_daughter(pat)).

% Negative examples

nex( has_daughter(pam)).      % Pam doen't have a daughter
nex( has_daughter(jim)).

start_hyp( [ [has_daughter(X)] / [X] ] ).      % Starting hypothesis
