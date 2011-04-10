% Find:
%
% 1. Prolog has some input/output features as well. Find print predicates that
% print out variables.
%  there's 'write'. I'll paste my minInList function in here and make it
%  write each element of the list while it checks them.
%  Aha, 'format' and 'writef' are very nice too.

    min(A,A,A).
    min(A,B,B) :- B < A.
    min(A,B,A) :- A < B.

    minInList([X|XS], M) :- minInList(XS, M1), min(X, M1, M), format('~a, ', X).
    minInList([X], X) :- format('~a, ', X).

% 2. Find a way to use the print predicates to print only successful solutions.
% How do they work? 
%
% To answer this one... I guess I want to use a rule that can have multiple
% correct answers. I'll take an example from the book.

    different(red, green). different(red, blue).
    different(green, red). different(green, blue).
    different(blue, red). different(blue, green).

    coloring(Alabama, Mississippi, Georgia, Tennessee, Florida) :-
        different(Mississippi, Tennessee),
        different(Mississippi, Alabama),
        different(Alabama, Tennessee),
        different(Alabama, Mississippi),
        different(Alabama, Georgia),
        different(Alabama, Florida),
        different(Georgia, Florida),
        different(Georgia, Tennessee),
        format('~a, ~a, ~a, ~a, ~a', [Alabama, Mississippi, Georgia, Tennessee, Florida]).

% Well, that will only print successful solutions, but I kind of feel like I've
% missed the point. All this will do is repeat the information that you already
% receive. Oh well, if I figure it out I'll come back to it.


% Do:
%
% 1. Modify the Sudoku solver to work on six-by-six puzzles (squares are 3x2)
% and 9x9 puzzles)
%
% 2. Make the Sudoku solver print prettier solutions.
%
% 3. Solve the Eight Queens problem by taking a list of queens. Rather than a
% tuple, represent each queen with an integer, from 1-8. Get the row of a queen
% by its position in the list and the column by the value in the list.
