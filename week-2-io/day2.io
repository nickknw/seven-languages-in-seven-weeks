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

# Probably the way he meant (plus bonus):
List myAverage2 := method(
    containsNonDigit := select(x, x asNumber() isNan()) size > 0
    if(containsNonDigit, Exception raise("An item in the list is not a number"))

    flatList := self flatten
    flatList reduce(+) / flatList size
)

list(1,2,3,4) myAverage2 println
#list(1,2,3,4,"a") myAverage2 println

# 5. Write a prototype for a two-dimensional list. The dim(x,y) method should
# allocate a list of y lists that are x elements long, set(x, y, value) should
# set a value, and get(x, y) should return that value.
#
List2D := List clone

List2D dim := method(x, y, 
    y repeat(
        inner := list()
        x repeat(inner push(nil))
        self append(inner) 
    ) 
)

# Hmmm, let's try this again

# Make sure you have this pull request before using this one
# https://github.com/stevedekorte/io/pull/85
List2D dim2 := method(x, y,
    y repeat(self append(Range 0 to(x) asList() map(nil)))
)

firstMatrix := List2D clone
firstMatrix dim(6,7) println
"" println

secondMatrix := List2D clone
secondMatrix dim2(6,7) println
"" println

# The below will cause infinite loop until you apply the change in the pull
# request above
testBounds := List2D clone
testBounds dim2(0, 2)
testBounds dim2(0, 2)

List2D set := method(x, y, value,
    self at(x) atPut(y, value)
)

List2D get := method(x, y, 
    self at(x) at(y)
)

firstMatrix set(2,4,"asdfad")
firstMatrix println
"" println

firstMatrix get(2,4) println
firstMatrix get(1,2) println

# 6. Bonus: Write a transpose method so that (new_matrix get(y, x)) == 
# matrix get(x,) on the original list
List2D transpose := method(
   self origGet := List2D getSlot("get")
   self get = method(x, y, origGet(y, x))
   
   self origSet := List2D getSlot("set")
   self set = method(x, y, origSet(y, x))
)

"2, 4: " print
firstMatrix get(2,4) println
"4, 2: " print
firstMatrix get(4,2) println
"transpose" println
firstMatrix transpose
"2, 4: " print
firstMatrix get(2,4) println
"4, 2: " print
firstMatrix get(4,2) println

# 7. Write the matrix to a file, and read a matrix from a file.

file := File with("matrix.txt")
file remove
file openForUpdating
file write(firstMatrix join(", "))
file close

file = File with("matrix.txt")
file openForReading
lines := file readLines
file close
lines at(0) type println
matrixFromFile := lines at(0) split(", ")
matrixFromFile type println
matrixFromFile println

# 8. Write a program that gives you ten tries to guess a random number from
# 1-100. If you would like, give a hint of "hotter" or "colder" after the first
# guess.

randomNumber := ((Random value) * 100 + 1) floor

i := 0
guess := 0
while(i < 10 and guess != randomNumber,
    ("Guess a number between 1 and 100: (guess " .. i+1 .. " of 10): ") print
    guess = ReadLine readLine
    guess = if(guess asNumber isNan, 0, guess asNumber)
    if(guess > randomNumber, "Too high" println)
    if(guess < randomNumber, "Too low" println)
    i = i + 1
)

if(guess == randomNumber, 
    "Congrats, you did it!" println, 
    "Too bad, maybe next time" println)
