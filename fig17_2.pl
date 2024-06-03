%  Figure 17.2  A definition of the planning space for the blocks world.
%  Note: For compatibility with Sicstus Prolog, predicate block/1 in Figure 17.2
%  is here replaced by is_block/1.

% Definition of action move( Block, From, To) in blocks world

% can( Action, Condition): Action possible if Condition true

can( move( Block, From, To), [ clear( Block), clear( To), on( Block, From)] ) :-
  is_block( Block),      % Block to be moved
  object( To),           % "To" is a block or a place
  To \== Block,          % Block cannot bå moved to itself
  object( From),         % "From" is a block or a place
  From \== To,           % Move to new position
  Block \== From.        % Block not moved from itself

% adds( Action, Relationships): Action establishes Relationships

adds( move(X,From,To), [ on(X,To), clear(From)]).

% deletes( Action, Relationships): Action destroys Relationships

deletes( move(X,From,To), [ on(X,From), clear(To)]).

object( X)  :-           % X is an objects if
  place( X)              % X is a place
  ;                      % or
  is_block( X).          % X is a block


% A blocks world

is_block( a).
is_block( b).
is_block( c).

place( 1).
place( 2).
place( 3).
place( 4).

%  A state in the blocks world
%
%         c
%         a b
%         ====
%  place  1234

state1( [ clear(2), clear(4), clear(b), clear(c), on(a,1), on(b,3), on(c,a) ] ).
