% time( DT):
%   DT is Prolog execution time in miliseconds 
%   between the previous call of time/1 and the current call of time/1


time(DT)  :- 
   statistics(runtime, [_,DT]).
