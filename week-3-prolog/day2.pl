% Find:
%
% 1. Some implementations of a Fibonacci series and factorials. How do they
% work?
%
% Fibonacci - http://cubbi.com/fibonacci/prolog.html

    fib(0,0).
    fib(1,1).
    fib(N,F) :- succ(N1,N), succ(N2,N1), fib(N1,F1), fib(N2,F2), plus(F1,F2,F).

% First establish the two base cases.
% Next, create a rule for the recursive case:
%   Find N-1 and N-2 
%   Find the N-1th fibonacci number
%   Find the N-2th fibonacci number
%   Add the N-1th and the N-2th fibonacci number
%   The result is the Nth fibonacci number
%
% Pretty straightforward!
%
%
% Factorial - http://boklm.eu/prolog/page_6.html

  factorial(0,1).
  factorial(X,Y) :-
      X1 is X - 1,
      factorial(X1,Z),
      Y is Z * X,!.

% First, establish the base case.
% Next, create a rule for the recursive case:
%   Find X - 1
%   Find the factorial of X - 1
%   Multiply the result by X
%   The result is the factorial of X
%
%
% 2. A real-world community using Prolog. What problems are they solving with it
% today?
%
% Nice SO question about this:
% http://stackoverflow.com/questions/130097/real-world-prolog-usage
%
% Some companies that use Prolog:
%   http://www.meridiansystems.com/products/prolog/construction-project-management.asp
%   http://www.intologic.com/
%   http://www.sics.se/isl/sicstuswww/site/customers.html
%   powerset (acquired by microsoft)
%
% Dr. Dobbs article on this:
% http://drdobbs.com/architecture-and-design/184405220
%
%
% 3. (optional) What are some of the problems of dealing with "not" expressions? Why
% do you have to be careful with negation in Prolog?
%
% Negation in Prolog is not *logical negation*, it is *negation as failure*.  So
% `not(X)` doesn't mean that X is false (like `¬X` would), it means that X can't
% be proven true. Something else you have to be careful with is putting negated
% predicates in the right order. Negation as failure is implemented using the
% `cut` and `fail` predicates. The short story is negating a predicate can
% cause subsequent predicates to be ignored.
%
% For a better and more in-depth explanation of `cut` and negation as failure, I
% strongly recommend the following links:
%
% * Negation In Prolog - http://pwnetics.wordpress.com/2011/04/10/negation-in-prolog/
% The author uses the wallace and grommit example from this book to show how
% assuming logical negation can lead to subtle errors.
%
% * Negation as failure - http://cs.union.edu/~striegnk/learn-prolog-now/html/node90.html#sec.l10.negation.as.failure
% A highly readable explanation of how negation as failure really works. Here is
% one of the opening paragraphs which really helped make it click for me:
%
% > As a first step, let's introduce another built in predicate fail/0. As its name
% > suggests, fail is a special symbol that will immediately fail when Prolog
% > encounters it as a goal. That may not sound too useful, but remember: when
% > Prolog fails, it tries to backtrack. Thus fail can be viewed as an instruction
% > to force backtracking. And when used in combination with cut, which blocks
% > backtracking, fail enables us to write some interesting programs, and in
% > particular, it lets us define exceptions to general rules.   
%
% If you find you need more background information first, try the page where they
% introduce cut: http://cs.union.edu/~striegnk/learn-prolog-now/html/node88.html#sec.l10.cut
%
% Do:
%
% 1. Reverse the elements of a list

    reverse(A,R) :- reverse(A,[],R).
    reverse([X|Y],Z,W) :- reverse(Y,[X|Z],W).
    reverse([],X,X).

% I ended up using the example from the tutorial I was following - even then it
% still took a bit to make sense to me. The middle accumulation parameter
% specifically. I'm going to try the problem that the tutorial gives immediately
% after: 
% 
% ------------
%
% Write a two-parameter version of 'reverse' that does not use the accumulating
% parameter idea. Use 'append' instead, for example, where one rule would be
% paraphrased like this ...
%   
%   reverse list [X|R] by reversing R to get T, then append T to [X]
%
% What about the efficiency of this version? Compare it to the given 'reverse'
% above.
%
% ------------
%
% This is the way I was attempting to do it first as well. It is (probably)
% less efficient than the first version, because when I append an element to the
% end of the list it likely has to walk the list each time. Don't know for sure
% without measuring though.

    reverseA([X|R], Result) :- reverse(R, T), append(T, [X], Result).
    reverseA([X], X).

% 2. Find the smallest element of a list

    min(A,A,A).
    min(A,B,B) :- B < A.
    min(A,B,A) :- A < B.

    minInList([X|XS], M) :- minInList(XS, M1), min(X, M1, M).
    minInList([X], X).

% 3. Sort the elements of a list.
%
% I'm just going to go for a very simple sort.

    takeout(X, [X|R], R).
    takeout(X, [F|R], [F|S]) :- takeout(X,R,S).

    mySort(List, [Min|Sorted]) :- 
        minInList(List, Min), 
        takeout(Min, List, Rest), 
        mySort(Rest, Sorted).
    mySort([X], [X]).

