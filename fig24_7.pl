%  Figure 24.7:  An AL0 advice-table for king and rook vs king.
%  The table consists of two rules and six pieces of advice.

%  King and Rook vs. King in Advice Language0


                % RULES

edge_rule :: if    their_king_edge and kings_close
            then  [ mate_in_2, squeeze, approach, keeproom,
                    divide_in_2, divide_in_3 ].

else_rule :: if  true
            then  [ squeeze, approach, keeproom,
                    divide_in_2, divide_in_3 ].


                % PIECES OF ADVICE

advice( mate_in_2,
        mate :
        not rooklost and their_king_edge :
        (depth=0) and legal  then  (depth=2) and checkmove :
        (depth=1) and legal ).

advice( squeeze,
        newroomsmaller and not rookexposed and
        rookdivides and not stalemate :
        not rooklost :
        (depth=0) and rookmove :
        nomove ).

advice( approach,
        okapproachedcsquare and not rookexposed and
        (rookdivides or lpatt) and (roomgt2 or not our_king_edge) :
        not rooklost :
        (depth=0) and kingdiagfirst :
        nomove ).

advice( keeproom,
        themtomove and not rookexposed and rookdivides and okorndle and
        (roomgt2 or not okedge) :
        not rooklost :
        (depth=0) and kingdiagfirst :
        nomove ).

advice( divide_in_2,
        themtomove and rookdivides and not rookexposed :
        not rooklost :
        (depth < 3) and legal :
        (depth < 2) and legal ).

advice( divide_in_3,
        themtomove and rookdivides and not rookexposed :
        not rooklost :
        (depth < 5) and legal :
        (depth < 4) and legal ).

