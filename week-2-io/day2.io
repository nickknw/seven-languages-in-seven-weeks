# Do:
# 
# 1. Write a program to find the nth Fibonacci number. Fib(1) is 1, and fib(4)
# is 3. As a bonus, solve the problem with recursion and with loops.

fib_recur := method(num, 
    if(num <= 2, 1, fib_recur(num - 1) + fib_recur(num - 2) )
)

fib_loop := method(num, 
    old := 0
    new := 1
    next := 0
    for(i, num, 1, -1, 
        next = old + new
        old = new
        new = next
    )
    old
)

fib_recur(4) println
fib_loop(4) println

fib_recur(8) println
fib_loop(8) println
