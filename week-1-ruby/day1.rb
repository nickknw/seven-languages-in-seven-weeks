# Find:
# 1. A method that substitutes a part of a string
puts "\nFind:"
puts "\n1."
puts "BAM".gsub "M", "TMAN"


# Do:
# 1. Print the string "Hello World"
puts "\nDo:" 
puts "\n1."
puts "Hello World"

# 2. For the string "Hello, Ruby," find the index of the word "Ruby."
puts "\n2."
# literally:
p "Hello, Ruby,".index "Ruby." 
# realistically:
puts "Hello, Ruby".index "Ruby"

# 3. Print your name ten times
puts "\n3."
puts "Nick " * 10

# 4. Print the string "This is sentence number 1," where the number 1 changes
# from 1 to 10
puts "\n4."
(1..10).each { |num| puts "This is sentence number #{num}" }

# Bonus: Write a program that picks a random number. Let a player guess the
# number, telling the player whether the guess is too low or too high.
puts "\nBonus:"

random_number = rand(1000) + 1
guess = 0

while guess != random_number do
    print "Pick a number between 1 and 1000: "
    guess = gets.to_i
    puts "Too low!" if guess < random_number
    puts "Too high!" if guess > random_number
end

puts "Got it! It was #{random_number}"
