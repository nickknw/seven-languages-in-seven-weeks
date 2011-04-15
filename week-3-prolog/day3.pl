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

    :- use_module(library(clpfd)).

    sudoku(Puzzle) :- 
    Puzzle = [S11, S12, S13, S14, S15, S16, S17, S18, S19,
              S21, S22, S23, S24, S25, S26, S27, S28, S29,
              S31, S32, S33, S34, S35, S36, S37, S38, S39,

              S41, S42, S43, S44, S45, S46, S47, S48, S49,
              S51, S52, S53, S54, S55, S56, S57, S58, S59,
              S61, S62, S63, S64, S65, S66, S67, S68, S69,

              S71, S72, S73, S74, S75, S76, S77, S78, S79,
              S81, S82, S83, S84, S85, S86, S87, S88, S89,
              S91, S92, S93, S94, S95, S96, S97, S98, S99],

    Puzzle ins 1..9,

    Row1 = [S11, S12, S13, S14, S15, S16, S17, S18, S19],
    Row2 = [S21, S22, S23, S24, S25, S26, S27, S28, S29],
    Row3 = [S31, S32, S33, S34, S35, S36, S37, S38, S39],
    Row4 = [S41, S42, S43, S44, S45, S46, S47, S48, S49],
    Row5 = [S51, S52, S53, S54, S55, S56, S57, S58, S59],
    Row6 = [S61, S62, S63, S64, S65, S66, S67, S68, S69],
    Row7 = [S71, S72, S73, S74, S75, S76, S77, S78, S79],
    Row8 = [S81, S82, S83, S84, S85, S86, S87, S88, S89],
    Row9 = [S91, S92, S93, S94, S95, S96, S97, S98, S99],

    Col1 = [S11, S21, S31, S41, S51, S61, S71, S81, S91],
    Col2 = [S12, S22, S32, S42, S52, S62, S72, S82, S92],
    Col3 = [S13, S23, S33, S43, S53, S63, S73, S83, S93],
    Col4 = [S14, S24, S34, S44, S54, S64, S74, S84, S94],
    Col5 = [S15, S25, S35, S45, S55, S65, S75, S85, S95],
    Col6 = [S16, S26, S36, S46, S56, S66, S76, S86, S96],
    Col7 = [S17, S27, S37, S47, S57, S67, S77, S87, S97],
    Col8 = [S18, S28, S38, S48, S58, S68, S78, S88, S98],
    Col9 = [S19, S29, S39, S49, S59, S69, S79, S89, S99],

    Square1 = [S11, S12, S13, S21, S22, S23, S31, S32, S33],
    Square2 = [S14, S15, S16, S24, S25, S26, S34, S35, S36],
    Square3 = [S17, S18, S19, S27, S28, S29, S37, S38, S39],

    Square4 = [S41, S42, S43, S51, S52, S53, S61, S62, S63],
    Square5 = [S44, S45, S46, S54, S55, S56, S64, S65, S66],
    Square6 = [S47, S48, S49, S57, S58, S59, S67, S68, S69],

    Square7 = [S71, S72, S73, S81, S82, S83, S91, S92, S93],
    Square8 = [S74, S75, S76, S84, S85, S86, S94, S95, S96],
    Square9 = [S77, S78, S79, S87, S88, S89, S97, S98, S99],

    valid([Row1, Row2, Row3, Row4, Row5, Row6, Row7, Row8, Row9,
           Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9,
           Square1, Square2, Square3, Square4, Square5, Square6, Square7, Square8, Square9]),

    label(Puzzle),
    prettier_print(Puzzle).

    valid([]).
    valid([Head|Tail]) :-
        all_different(Head),
        valid(Tail).

% 2. Make the Sudoku solver print prettier solutions.

    prettier_print([]).
    prettier_print(Puzzle) :- prettier_print(0, Puzzle).

    prettier_print(0, Puzzle) :- 
        writeln('┌───────┬───────┬───────┐'), 
        prettier_print(1, Puzzle).
    prettier_print(4, Puzzle) :- 
        writeln('│───────┼───────┼───────│'), 
        prettier_print(5, Puzzle).
    prettier_print(8, Puzzle) :- 
        writeln('│───────┼───────┼───────│'), 
        prettier_print(9, Puzzle).
    prettier_print(12, []) :- 
        writeln('└───────┴───────┴───────┘').

    prettier_print(N, [Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9 | Puzzle]) :- 
        member(N, [1,2,3,5,6,7,9,10,11]),
        %N =\= 0, N =\= 4, N =\= 8, N =\= 13,
        % note to self about above: remember, prolog's pattern matching isn't
        % like pattern matching in other languages

        format('│ ~d ~d ~d │ ~d ~d ~d │ ~d ~d ~d │~n', [Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8, Col9]), 
        succ(N, N1),
        prettier_print(N1, Puzzle).

% test array:
% [7, 3, _, _, 1, _, _, _, _, 8, _, _, 2, _, _, 4, _, _, 4, _, _, _, _, 5, _, _, _, _, _, 4, _, _, 7, 3, 8, _, _, 8, _, _, 3, _, _, 4, _, _, 1, 2, _, _, _, 7, _, _, _, _, _, 8, _, _, _, _, 9, _, _, 9, _, _, 2, _, _, 4, _, _, _, _, 5, _, _, 2, 3] 


% 3. Solve the Eight Queens problem by taking a list of queens. Rather than a
% tuple, represent each queen with an integer, from 1-8. Get the row of a queen
% by its position in the list and the column by the value in the list.

% ...I think I'm going to leave this one.

    valid_queen((_, Col)) :- member(Col, [1,2,3,4,5,6,7,8]).

    valid_board([]).
    valid_board([Head|Tail]) :- valid_queen(Head), valid_board(Tail).

    cols([], []).
    cols([(_, Col)|QueensTail], [Col|ColsTail]) :-
        cols(QueensTail, ColsTail).

    diags1([], []).
    diags1([(Row, Col)|QueensTail], [Diagonal|DiagonalsTail]) :-
        Diagonal is Col - Row,
        diags1(QueensTail, DiagonalsTail).

    diags2([], []).
    diags2([(Row, Col)|QueensTail], [Diagonal|DiagonalsTail]) :-
        Diagonal is Col + Row,
        diags2(QueensTail, DiagonalsTail).

    eight_queens(Board) :-
        Board = [(1, _), (2, _), (3, _), (4, _), (5, _), (6, _), (7, _), (8, _)],
        valid_board(Board),

        cols(Board, Cols),
        diags1(Board, Diags1),
        diags2(Board, Diags2),

        all_different(Cols),
        all_different(Diags1),
        all_different(Diags2).


% Call with eight_queens(Board).
