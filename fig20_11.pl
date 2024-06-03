% Figure 20.11  A program that induces if-then rules.


% Learning of simple if-then rules

:-  op( 300, xfx, <==).

% learn( Class): collect learning examples into a list, construct and
% output a description for Class, and assert the corresponding rule about Class

learn( Class)  :-
   bagof( example( ClassX, Obj), example( ClassX, Obj), Examples),        % Collect examples
   learn( Examples, Class, Description),                                  % Induce rule   
   nl, write( Class), write('  <== '), nl,                                % Output rule   
   writelist( Description),
   assert( Class  <==  Description).                                      % Assert rule

% learn( Examples, Class, Description):
%    Description covers exactly the examples of class Class in list Examples

learn( Examples, Class, [])  :-
   \+ member( example( Class, _ ), Examples).               % No example to cover 

learn( Examples, Class, [Conj | Conjs])  :-
   learn_conj( Examples, Class, Conj),
   remove( Examples, Conj, RestExamples),                    % Remove examples that match Conj   
   learn( RestExamples, Class, Conjs).                       % Cover remaining examples 

% learn_conj( Examples, Class, Conj):
%    Conj is a list of attribute values satisfied by some examples of class Class and
%    no other class

learn_conj( Examples, Class, [])  :-
   \+ ( member( example( ClassX, _ ), Examples),            % There is no example
   ClassX \== Class), !.                                     % of different class 

learn_conj( Examples, Class, [Cond | Conds])  :-
   choose_cond( Examples, Class, Cond),                      % Choose attribute value   
   filter( Examples, [ Cond], Examples1),
   learn_conj( Examples1, Class, Conds).

choose_cond( Examples, Class, AttVal)  :-
   findall( AV/Score, score( Examples, Class, AV, Score), AVs),
   best( AVs, AttVal).                                       % Best score attribute value 

best( [ AttVal/_], AttVal).

best( [ AV0/S0, AV1/S1 | AVSlist], AttVal)  :-
   S1  >  S0, !,                                             % AV1 better than AV0   
   best( [AV1/S1 | AVSlist], AttVal)
   ;
   best( [AV0/S0 | AVSlist], AttVal).

% filter( Examples, Condition, Examples1):
%    Examples1 contains elements of Examples that satisfy Condition

filter( Examples, Cond, Examples1)  :-
   findall( example( Class, Obj),
                ( member( example( Class, Obj), Examples), satisfy( Obj, Cond)),
                Examples1).

% remove( Examples, Conj, Examples1):
%    removing from Examples those examples that are covered by Conj gives Examples1

remove( [], _, []).

remove( [example( Class, Obj) | Es], Conj, Es1)  :-
   satisfy( Obj, Conj), !,                                    % First example matches Conj   
   remove( Es, Conj, Es1).                                    % Remove it 

remove( [E | Es], Conj, [E | Es1])  :-                        % Retain first example   
   remove( Es, Conj, Es1).

satisfy( Object, Conj)  :-
   \+ ( member( Att = Val, Conj),
         member( Att = ValX, Object),
         ValX \== Val).

score( Examples, Class, AttVal, Score)  :-
   candidate( Examples, Class, AttVal),          	% A suitable attribute value   
   filter( Examples, [ AttVal], Examples1),      	% Examples1 satisfy condition Att = Val     
   length( Examples1, N1),                       	% Length of list   
   count_pos( Examples1, Class, NPos1),          	% Number of positive examples   
   NPos1 > 0,                                    	% At least one positive example matches AttVal
   Score is (NPos1 + 1) / (N1 + 2).			% Laplace estimate of probability of Class

candidate( Examples, Class, Att = Val)  :-
   attribute( Att, Values),                      	% An attribute   
   member( Val, Values),                         	% A value   
   suitable( Att = Val, Examples, Class).

suitable( AttVal, Examples, Class)  :-            
    % At least one negative example must not match AttVal
   member( example( ClassX, ObjX), Examples),
   ClassX \== Class,                                     % Negative example   
   \+ satisfy( ObjX, [ AttVal]), !.                      % that does not match 

% count_pos( Examples, Class, N):
%    N is the number of positive examples of Class

count_pos( [], _, 0).

count_pos( [example( ClassX,_ ) | Examples], Class, N)  :-
   count_pos( Examples, Class, N1),
   ( ClassX = Class, !, N is N1 + 1; N = N1).

writelist( []).

writelist( [X | L])  :-
   tab( 2), write( X), nl,
   writelist( L).
