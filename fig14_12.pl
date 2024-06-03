%   Figure 14.12  Best-first AND/OR search program.


/*  BEST-FIRST AND/OR SEARCH

    This program only generates one solution. This
    solution is guaranteed to be a cheapest one if the
    heuristic function used is a lower bound of the actual
    costs of solution trees.

    Search tree is either:

      tree( Node, F, C, SubTrees)      tree of candidate solutions

      leaf( Node, F, C)                leaf of a search tree

      solvedtree( Node, F, SubTrees)   solution tree

      solvedleaf( Node, F)             leaf of solution tree

    C is the cost of the arc pointing to Node

    F = C + H,  where H is the heuristic estimate of an optimal
                solution subtree rooted in Node

    SubTrees are always ordered so that:
       (1) all solved subtrees are at end of list
       (2) other (unsolved subtrees) are ordered according to
           ascending F-values
*/

:-  op( 500, xfx, : ).

:-  op( 600, xfx, ---> ).

andor( Node, SolutionTree)  :-
  expand( leaf( Node, 0, 0), 9999, SolutionTree, yes).       % Assuming 9999 > any F-value

% Procedure expand( Tree, Bound, NewTree, Solved)
% expands Tree with Bound producing NewTree whose
% 'solution-status' is Solved

% Case 1: bound exceeded

expand( Tree, Bound, Tree, no)  :-
  f( Tree, F),  F > Bound, !.         % Bound exceeded

% In all remaining cases  F =< Bound

% Case 2: goal encountered

expand( leaf( Node, F, C), _, solvedleaf( Node, F), yes)  :-
  goal(Node), !.

% Case 3: expanding a leaf

expand( leaf( Node, F, C), Bound, NewTree, Solved)  :-
  (  expandnode( Node, C, Tree1), !,
       expand( Tree1, Bound, NewTree, Solved);
     Solved = never, !).   % No successors, dead end

% Case 4: expanding a tree

expand( tree( Node, F, C, SubTrees), Bound, NewTree, Solved)  :-
  Bound1 is Bound - C,
  expandlist( SubTrees, Bound1, NewSubs, Solved1),
  continue( Solved1, Node, C, NewSubs, Bound, NewTree, Solved).

% expandlist( Trees, Bound, NewTrees, Solved)
% expands tree list Trees with Bound producing
% NewTrees whose 'solved-status' is Solved

expandlist( Trees, Bound, NewTrees, Solved)  :-
  selecttree( Trees, Tree, OtherTrees, Bound, Bound1),
  expand( Tree, Bound1, NewTree, Solved1),
  combine( OtherTrees, NewTree, Solved1, NewTrees, Solved).

% 'continue' decides how to continue after expanding a tree list

continue( yes, Node, C, SubTrees, _, solvedtree(Node,F,SubTrees), yes) :-
  backup( SubTrees, H),  F is C + H, !.

continue( never, _, _, _, _, _, never)  :-  !.

continue( no, Node, C, SubTrees, Bound, NewTree, Solved)  :-
  backup( SubTrees, H),  F is C + H, !,
  expand( tree( Node, F, C, SubTrees), Bound, NewTree, Solved).

% 'combine' combines results of expanding a tree and a tree list

combine( or:_, Tree, yes, Tree, yes) :- !.        % OR-list solved

combine( or:Trees, Tree, no, or:NewTrees, no)  :-
  insert( Tree, Trees, NewTrees), !.              % OR-list still unsolved

combine( or:[], _, never, _, never)  :- !.        % No more candidates

combine( or:Trees, _, never, or:Trees, no)  :- !. % There are more candidates

combine( and:Trees, Tree, yes, and:[Tree|Trees], yes)  :-
  allsolved(Trees), !.                            % AND-list solved

combine( and:_, _, never, _, never) :- !.         % AND-list unsolvable

combine( and:Trees, Tree, YesNo, and:NewTrees, no)  :-
  insert( Tree, Trees, NewTrees), !.              %  AND-list still unsolved

% 'expandnode' makes a tree of a node and its successors

expandnode( Node, C, tree( Node, F, C, Op:SubTrees))  :-
  Node  --->  Op:Successors,
  evaluate( Successors, SubTrees),
  backup( Op:SubTrees, H), F is C + H.

evaluate( [], []).

evaluate( [Node/C|NodesCosts], Trees)  :-
  h( Node, H), F is C + H,
  evaluate( NodesCosts, Trees1),
  insert( leaf( Node, F, C), Trees1, Trees).

% 'allsolved' checks whether all trees in a tree-list are solved

allsolved([]).

allsolved([Tree|Trees])  :-
  solved(Tree),
  allsolved(Trees).

solved( solvedtree(_,_,_)).

solved( solvedleaf(_,_)).

f( Tree, F)  :-               % Extract F-value of a tree
  arg( 2, Tree, F), !.        % F is the 2nd argument in Tree

% insert( Tree, Trees, NewTrees) inserts Tree into
% tree-list Trees producing NewTrees

insert( T, [], [T])  :-  !.

insert( T, [T1|Ts], [T,T1|Ts])  :-
  solved(T1), !.

insert( T, [T1|Ts], [T1|Ts1])  :-
  solved(T),
  insert( T, Ts, Ts1), !.

insert( T, [T1|Ts], [T,T1|Ts])  :-
  f( T, F), f(T1, F1), F =< F1, !.

insert( T, [T1|Ts], [T1|Ts1])  :-
  insert( T, Ts, Ts1).

% 'backup' finds the backed-up F-value of AND/OR tree-list

backup( or:[Tree|_], F)  :-    % First tree in OR-list is best
  f( Tree, F), !.

backup( and:[], 0)  :-  !.

backup( and:[Tree1|Trees], F)  :-
  f( Tree1, F1),
  backup( and:Trees, F2),
  F  is  F1 + F2,  !.

backup( Tree, F)  :-
  f( Tree, F).

% Relation selectree( Trees, BestTree, OtherTrees, Bound, Bound1):
% OtherTrees is an AND/OR list Trees without its best member
% BestTree; Bound is expansion bound for Trees, Bound1 is
% expansion bound for BestTree

selecttree( Op:[Tree], Tree, Op:[], Bound, Bound) :- !.      % The only candidate

selecttree( Op:[Tree|Trees], Tree, Op:Trees, Bound, Bound1)  :-
  backup( Op:Trees, F),
  ( Op = or, !, min( Bound, F, Bound1);
    Op = and, Bound1 is Bound - F).

min( A, B, A)  :-  A < B, !.

min( A, B, B).

