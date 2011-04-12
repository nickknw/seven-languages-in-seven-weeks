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

    % SWI Prolog doesn't have fd_domain or fd_all_different. Let's make them!
    fd_domain([], _, _) :- true.
    fd_domain([X|XS], Low, High) :- between(Low, High, X), fd_domain(XS, Low, High).

    fd_all_different([]) :- true.
    fd_all_different([X|XS]) :- not(member(X, XS)), fd_all_different(XS).

    % after testing that, they don't work well because they are very slow. The
    % constraint programming library does something special to make this work
    % fast, so let's use it.
    :- use_module(library(clpfd)).

    valid([]).
    valid([Head|Tail]) :-
        all_different(Head),    % in the book, this is 'fd_all_different'
        valid(Tail).

    % beginning of sudoku rule itself
    sudoku(Puzzle) :- 
    Puzzle = [S11, S12, S13, S14,
              S21, S22, S23, S24,
              S31, S32, S33, S34,
              S41, S42, S43, S44],
    Puzzle ins 1..4,    % in the book, this is 'fd_domain'

    Row1 = [S11, S12, S13, S14],
    Row2 = [S21, S22, S23, S24],
    Row3 = [S31, S32, S33, S34],
    Row4 = [S41, S42, S43, S44],

    Col1 = [S11, S21, S31, S41],
    Col2 = [S12, S22, S32, S42],
    Col3 = [S13, S23, S33, S43],
    Col4 = [S14, S24, S34, S44],

    Square1 = [S11, S12, S21, S22],
    Square2 = [S13, S14, S23, S24],
    Square3 = [S31, S32, S41, S42],
    Square4 = [S33, S34, S43, S44],

    valid([Row1, Row2, Row3, Row4,
           Col1, Col2, Col3, Col4,
           Square1, Square2, Square3, Square4]),

    pretty_print(Puzzle).


% 2. Make the Sudoku solver print prettier solutions.

    pretty_print([]).
    pretty_print([Col1, Col2, Col3, Col4 | RestOfPuzzle]) :- 
        writeln([Col1, Col2, Col3, Col4]),
        pretty_print(RestOfPuzzle).

% 3. Solve the Eight Queens problem by taking a list of queens. Rather than a
% tuple, represent each queen with an integer, from 1-8. Get the row of a queen
% by its position in the list and the column by the value in the list.
