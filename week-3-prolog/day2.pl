% Find:
%
% 1. Some implementations of a Fibonacci series and factorials. How do they
% work?
%
% Fibonacci - http://cubbi.com/fibonacci/prolog.html
% 

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
% Because negation of X doesn't mean that X is false, it means that X can't be
% proven true.
%
%
% Do:
%
% 1. Reverse the elements of a list
%
% 2. Find the smallest element of a list
%
% 3. Sort the elements of a list.
