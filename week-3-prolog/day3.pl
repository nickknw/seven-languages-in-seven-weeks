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
% and 9x9 puzzles).
%
% I chose to just do 9x9:

    :- use_module(library(clpfd)).

    sudoku(Rows) :-
        % split into rows
        Rows = [A, B, C, D, E, F, G, H, I],
        % and columns
        transpose(Rows, Columns), 

        % some bounds checking
        append(Rows, FlattenedRows), FlattenedRows ins 1..9,
        length(Rows, 9),
        length(Columns, 9),

        % all rows valid
        maplist(all_distinct, Rows),

        % all columns valid
        maplist(all_distinct, Columns),

        % all blocks valid
        valid_blocks(A, B, C),
        valid_blocks(D, E, F),
        valid_blocks(G, H, I),

        prettier_print(FlattenedRows).

    valid_blocks([], [], []).  
    valid_blocks([A1, A2, A3 | As], [B1, B2, B3 | Bs], [C1, C2, C3 | Cs]) :-
        all_distinct([A1, A2, A3, B1, B2, B3, C1, C2, C3]),
        valid_blocks(As, Bs, Cs).


    problem(1, [[_,_,_,_,_,_,_,_,_],                                   
                [_,_,_,_,_,3,_,8,5],                                   
                [_,_,1,_,2,_,_,_,_],                                   
                [_,_,_,5,_,7,_,_,_],                                   
                [_,_,4,_,_,_,1,_,_],                                   
                [_,9,_,_,_,_,_,_,_],                                  
                [5,_,_,_,_,_,_,7,3],                                  
                [_,_,2,_,1,_,_,_,_],                                   
                [_,_,_,_,4,_,_,_,9]]).

    % can test with:
    % ?- problem(1, Board), sudoku(Board).

    %label(Rows),

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
