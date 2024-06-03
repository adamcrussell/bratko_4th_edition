%  Figure 10.10  AVL-dictionary insertion. In this program, an attempt
%  to insert a duplicate will fail. See Fig. 10.9 for combine.


% addavl( Tree, X, NewTree): insertion into AVL-dictionary
%    Tree = t( Left, Root, Right)/HeightOfTree
%    Empty tree = nil/0


addavl( nil/0, X, t(nil/0,X,nil/0)/1).      % Add X to empty tree

addavl( t(L,Y,R)/Hy, X, NewTree)  :-        % Add X to nonempty tree
   gt( Y, X),
   addavl( L, X, t(L1,Z,L2)/_),             % Add into left subtree
   combine( L1, Z, L2, Y, R, NewTree).      % Combine ingredients of NewTree

addavl( t(L,Y,R)/Hy, X, NewTree)  :-
   gt( X, Y),
   addavl( R, X, t(R1,Z,R2)/_),             % Add into right subtree
   combine( L, Y, R1, Z, R2, NewTree).

combine( T1/H1, A, t(T21,B,T22)/H2, C, T3/H3,
         t( t(T1/H1,A,T21)/Ha, B, t(T22,C,T3/H3)/Hc)/Hb )  :-
   H2 > H1, H2 > H3,                        % Middle subtree tallest
   Ha is H1 + 1,
   Hc is H3 + 1,
   Hb is Ha + 1.

combine( T1/H1, A, T2/H2, C, T3/H3,
         t( T1/H1, A, t(T2/H2,C,T3/H3)/Hc)/Ha )  :-
   H1 >= H2, H1 >= H3,                      % Tall left subtree
   max1( H2, H3, Hc),
   max1( H1, Hc, Ha).

combine( T1/H1, A, T2/H2, C, T3/H3,
         t( t(T1/H1,A,T2/H2)/Ha, C, T3/H3)/Hc )  :-
   H3 >= H2, H3 >= H1,                      % Tall right subtree
   max1( H1, H2, Ha),
   max1( Ha, H3, Hc).


max1( U, V, M)  :-           % M is 1 + max. of U and V
   U > V, !, M is U + 1
   ;
   M is V + 1.
