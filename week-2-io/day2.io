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

# 2. How would you change / to return 0 if the denominator is zero?
#
# The tricky bit is saving a reference to the old method:
Number origDiv := Number getSlot("/")

# Overriding the / method is surprisingly straightforward
Number / = method(denom, if(denom == 0, 0, self origDiv(denom)))

4 / 2 println
4 / 0 println

# 3. Write a program to add up all of the numbers in a two-dimensional array.
addUp2DArray := method(array, array flatten reduce(+))

addUp2DArray(list(2,3,4,5)) println
addUp2DArray(list(2,3, list(1,1,1), 4,5)) println

# 4. Add a slot called myAverage to a list that computes the average of all the
# numbers in a list. What happens if there are no numbers in a list? (Bonus:
# Raise an Io exception if any item in the list is not a number.)

# Easy way:
List myAverage := method(self average)

# Probably the way he meant:
List myAverage2 := method(
    containsNonDigit := select(x, x asNumber() isNan()) size > 0
    if(containsNonDigit, Exception raise("An item in the list is not a number"))

    flatList := self flatten
    flatList reduce(+) / flatList size
)

list(1,2,3,4) myAverage2 println
list(1,2,3,4,"a") myAverage2 println
