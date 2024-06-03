
Note: Below is the original readme file. The files in this repository were intended for distribution by the author, however,
they have been unavailable from the publisher for many years.

###############
ORIGINAL README
###############


PROGRAMS FROM:

I. Bratko, Prolog Programming for Artificial Intelligence, 4th edn.,
Pearson Education / Addison-Wesley 2012


Most of the programs directly correspond to figures in the book. 
For easy identification, a file named figNN.pl contains the program that
appears in Figure NN in the book, and a comment of the form 

%  Figure NN 

was inserted at the beginning of each program. For example, the 
file fig18_8.pl contains the program that appears as Figure 18.8 
in the book. "pl" is the usual extension of Prolog program files.

File frequent.pl contains definitions of some frequently used predicates 
such as member/2 and conc/3. These are often used by other programs in the
book. So to run a program, it is easiest to first load the file frequent.pl 
(by consulting or compiling this file). The file frequent.pl includes 
some predicates that may already be included among the built-in predicates, 
depending on the implementation of Prolog. For example, negation as failure 
written as not Goal is also included below for compatibility with Prologs that 
only use the notation \+ Goal instead. When loading into Prolog the definition 
of a predicate that is already built-in, Prolog will typically just issue a 
warning message and ignore the new definition.
