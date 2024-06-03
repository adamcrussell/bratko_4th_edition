%  Figure 7.4:  Fitting four blocks into a box.

%  Placing blocks into a box 
%  This is a planar version, all blocks and boxes are rectangles
%  Blocks and boxes are to be aligned with x,y axes

% block( BlockName, dim(Width, Length)): 
%     specification of a block dimensions, height does not matter

block( b1, dim( 5.0, 3.0)).		% Block b1 has size 5 by 3
block( b2, dim( 2.0, 6.0)).
block( b3, dim( 1.0, 2.4)).
block( b4, dim( 1.0, 5.0)).

box( box1, dim( 6.0, 6.0)).		% Box box1 has size 6 by 6
box( box2, dim( 7.0, 5.0)).
box( box3, dim( 6.0, 5.0)).

% Representation of rectangles:
%    rect( pos(X,Y), dim(A,B)) represents a rectangle of size A by B at position pos(X,Y)

% rotate( Rectangle, RotatedRectangle):
%     Rotation of rectangle in X-Y plane , always aligned with X-Y axes 

rotate( rect( Pos, Dim), rect( Pos, Dim)).			% Zero rotation
rotate( rect( Pos, dim( A, B)), rect( Pos, dim( B, A))).	% Rotated by 90 degrees

% block_rectangle( BlockName, Rectangle):
%    Rectangle is a minimal rectangle that accommodates block BlockName

block_rectangle( BlockName, rect( Pos, Dim))  :-		% Rectangle at any position
   block( BlockName, Dim0),				% Dimensions of BlockName
   rotate( rect( Pos, Dim0), rect( Pos, Dim)).		% Block possibly rotated 

% inside( Rectangle1, Rectangle2): Rectangle1 completely inside Rectangle2

inside( rect( pos( X1, Y1), dim( Dx1, Dy1)), rect( pos( X2, Y2), dim( Dx2, Dy2))) :-
  { X1 >= X2, Y1 >= Y2, X1+Dx1 =< X2+Dx2, Y1+Dy1 =< Y2+Dy2}.

% no_overlap( Rect1, Rect2):  Rectangles Rect1 and Rect2 do not overlap

no_overlap( rect( pos(X1,Y1), dim(Dx1,Dy1)), rect( pos(X2,Y2), dim(Dx2,Dy2)))  :-
   { X1 + Dx1 =< X2;   X2 + Dx2 =< X1 ;	% Rectangles left or right of each other
      Y1 + Dy1 =< Y2;  Y2 + Dy2 =< Y1 }.	% Rectangles above or below of each other

% fit( Box, Block1, Block2, Block3, Block4): 
%    The 4 blocks, whose rectangles are Block1, Block2, ... fit into a box 

fit( BoxName, Block1, Block2, Block3, Block4)  :-
   box( BoxName, Dim), Box = rect( pos( 0.0, 0.0), Dim),
   block_rectangle( b1, Block1),  inside( Block1, Box),	% Block b1 inside Box
   block_rectangle( b2, Block2),  inside( Block2, Box),	% Block b2 inside Box
   block_rectangle( b3, Block3),  inside( Block3, Box),
   block_rectangle( b4, Block4),  inside( Block4, Box), 
   no_overlap( Block1, Block2),			% No overlap between blocks b1 and b2
   no_overlap( Block1, Block3),			% No overlap between b1 and b3
   no_overlap( Block1, Block4),
   no_overlap( Block2, Block3),
   no_overlap( Block2, Block4),
   no_overlap( Block3, Block4).


