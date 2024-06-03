%  Figure 24.6:  A miniature implementation of Advice Language 0
%
%  This program plays a game from a given starting position
%  using knowledge represented in Advice Language 0
%  
%  This is Figure 15.6 of Prolog for AI, 1st edition


:-  op( 200, xfy, [ :, ::]).
:-  op( 220, xfy, ..).
:-  op( 185, fx, if).
:-  op( 190, xfx, then).
:-  op( 180, xfy, or).
:-  op( 160, xfy, and).
:-  op( 140, fx, not).

:- undefined( fail).	       % Undefined predicates will just fail

playgame( Pos)  :-             % Play a game starting in Pos
  playgame( Pos, nil).         % Start with empty forcing tree

playgame( Pos, ForcingTree)  :-
  show( Pos),
  (  end_of_game( Pos),                    % End of game?
       write('End of game'), nl, !;
     playmove( Pos, ForcingTree, Pos1, ForcingTree1), !,
       playgame( Pos1, ForcingTree1)).

         % Play 'us' move according to forcing tree

playmove( Pos, Move..FTree1, Pos1, FTree1)  :-
  side( Pos, w),                 % White = 'us'
  legalmove( Pos, Move, Pos1),
  showmove( Move).

         % Read  'them' move

playmove( Pos, FTree, Pos1, FTree1)  :-
  side( Pos, b),
  write( 'Your move: '),
  read( Move),
  (  legalmove( Pos, Move, Pos1),
       subtree( FTree, Move, FTree1), !;    % Move down forcing-tree
     write( 'Illegal move'), nl,
       playmove( Pos, FTree, Pos1, FTree1) ).

       % If current forcing-tree is empty generate a new one

playmove( Pos, nil, Pos1, FTree1)  :-
  side( Pos, w),
  resetdepth( Pos, Pos0),                   % Pos0 = Pos with depth 0
  strategy( Pos0, FTree), !,                % Generate new forcing-tree
  playmove( Pos0, FTree, Pos1, FTree1).


       % Select a forcing-subtree corresponding to Move

subtree( FTrees, Move, FTree)  :-
  member( Move..FTree, FTrees), !.

subtree( _, _, nil).


strategy( Pos, ForcingTree)  :-                % Find forcing-tree for Pos
  Rule :: if Condition then AdviceList,         % Consult advice table
  holds( Condition, Pos, _), !,                % Match Pos against precondition
  member( AdviceName, AdviceList),             % Try pieces-of-advice in turn
  nl, write('Trying '), write( AdviceName), 
  satisfiable( AdviceName, Pos, ForcingTree), !.  % Satisfy AdviceName in Pos

satisfiable( AdviceName, Pos, FTree)  :-
  advice( AdviceName, Advice),            % Retrieve piece-of-advice
  sat( Advice, Pos, Pos, FTree).	  % 'sat' needs two positions for
                                          %  comparison predicates

sat( Advice, Pos, RootPos, FTree)  :-
  holdinggoal( Advice, HG),
  holds( HG, Pos, RootPos),               % Holding-goal satisfied
  sat1( Advice, Pos, RootPos, FTree).

sat1( Advice, Pos, RootPos, nil)  :-
  bettergoal( Advice, BG),
  holds( BG, Pos, RootPos), !.            % Better-goal satisfied

sat1( Advice, Pos, RootPos, Move..FTrees)  :-
  side( Pos, w), !,                             % White = 'us'
  usmoveconstr( Advice, UMC),
  move( UMC, Pos, Move, Pos1),	    % A move satisfying move constr.
  sat( Advice, Pos1, RootPos, FTrees).

sat1( Advice, Pos, RootPos, FTrees)  :-
  side( Pos, b), !,                             % Black = 'them'
  themmoveconstr( Advice, TMC),
  bagof( Move..Pos1, move( TMC, Pos, Move, Pos1), MPlist),
  satall( Advice, MPlist, RootPos, FTrees).   % Satisfiable in all successors

satall( _, [], _, []).

satall( Advice, [ Move..Pos | MPlist], RootPos, [Move..FT|MFTs])  :-
  sat( Advice, Pos, RootPos, FT),
  satall( Advice, MPlist, RootPos, MFTs).


%  Interpreting holding and better-goals:
%  A goal is an AND/OR/NOT combination of predicate names

holds( Goal1 and Goal2, Pos, RootPos)  :-  !,
  holds( Goal1, Pos, RootPos),
  holds( Goal2, Pos, RootPos).

holds( Goal1 or Goal2, Pos, RootPos)  :-  !,
  (  holds( Goal1, Pos, RootPos);
     holds( Goal2, Pos, RootPos)  ).

holds( not Goal, Pos, RootPos)  :-  !,
  \+ holds( Goal, Pos, RootPos).

holds( Pred, Pos, RootPos)  :-
  ( Cond =.. [ Pred, Pos];  	   % Most predicates do not depend on RootPos
    Cond =.. [ Pred, Pos, RootPos] ),
  call( Cond).


%  Interpreting move constraints

move( MC1 and MC2, Pos, Move, Pos1)  :-  !,
  move( MC1, Pos, Move, Pos1),
  move( MC2, Pos, Move, Pos1).

move( MC1 then MC2, Pos, Move, Pos1)  :-  !,
  (  move( MC1, Pos, Move, Pos1);
     move( MC2, Pos, Move, Pos1) ).


%  Selectors for components of piece-of-advice

bettergoal( BG : _, BG).

holdinggoal( BG : HG : _, HG).

usmoveconstr( BG : HG : UMC : _, UMC).

themmoveconstr( BG : HG : UMC : TMC, TMC).


member( X, [X|L]).

member( X, [Y|L])  :-
  member( X, L).



