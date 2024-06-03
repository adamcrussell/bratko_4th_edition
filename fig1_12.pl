% Figure 1.12: Crosswords

% Words that may be used in the solution

word( d,o,g).		word( r,u,n).		word( t,o,p).		word( f,i,v,e).
word( f,o,u,r).		word( l,o,s,t).		word( m,e,s,s).		word( u,n,i,t).	
word( b,a,k,e,r).	word( f,o,r,u,m).	word( g,r,e,e,n).	word( s,u,p,e,r).
word( p,r,o,l,o,g).	word( v,a,n,i,s,h).	word( w,o,n,d,e,r).	word( y,e,l,l,o,w).	

solution( L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16)  :-
  word( L1,L2,L3,L4,L5),		%  Top horizontal word
  word( L9,L10,L11,L12,L13,L14),	%  Second horizontal word
  word( L1,L6,L9,L15),			%  First vertical word
  word( L3,L7,L11),			%  Second vertical word
  word( L5,L8,L13,L16).			%  Third vertical word

