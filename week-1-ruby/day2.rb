# Find:
# 1. Find out how to access files with and without code blocks. What is the
# benefit of the code block?
puts "\nFind:"
puts "\n1."

file = File.open("tmp.txt", "w+")
file.puts "a spoonful is great but I'd rather have a bowl"
file.close

# safer, less error-prone, more readable
File.open("tmp2.txt", "w+") { |file|
    file.puts "a spoonful is great but I'd rather have a bowl"
}

puts IO.read("tmp.txt")
puts IO.read("tmp2.txt")

# 2. How would you translate a hash to an array? Can you translate arrays to
# hashes?
puts "\n2."
scores = { gary: 5, nick: 11, ted: 8, the_dude: 9 }
print "hash: "; p scores
print "array1: "; p scores.to_a
print "array2: "; p scores.to_a.flatten

scores_array1 = scores.to_a
print "array1 to hash again 1: "; p scores_array1.inject(Hash.new) { |memo, pair| memo[pair.first] = pair.last; memo }
print "array1 to hash again 2: "; p Hash[scores_array1]
scores_array2 = scores.to_a.flatten
print "array2 to hash again 3: "; p Hash[*scores_array2]
puts "Yup."

# 3. Can you iterate through a hash?
puts "\n3."
scores.each { |key, value| puts "key:'#{key}', value:'#{value}'" }
puts "Yup."

# 4. You can use Ruby arrays as stacks. What other common data structures to
# arrays support?
puts "\n4."
puts "queue/deque: " 
deque = [].push("1").push("2")
deque.unshift("a").unshift("b")
p deque
puts deque.shift
puts deque.shift
puts deque.pop
puts deque.pop

puts "list: "
list = [1,2,3].insert(2, "c")
puts list
puts "removed: " + list.delete("c")

puts "(rudimentary) bag/set:"
bag = [1,2,3,3,4,5]
p bag
set = bag.uniq
other_set = [3,5]
p set
p set & other_set

puts "(rudimentary) matrix:"
matrix = [[1,2,3],[4,5,6],[7,8,9]]
p matrix
p matrix.transpose


# Do:
# 1. Print the contents of an array of sixteen numbers, four numbers at a time,
# using just each. Now, do the same with each_slice in Enumerable
puts "\nDo:"
puts "\n1."
sixteen_numbers = [*(1..16)]
sixteen_numbers.each do |number| 
        p sixteen_numbers[((number-4)...number)] if number % 4 == 0
end

puts "and" 

sixteen_numbers.each_slice(4) { |slice| p slice }


# 2. The Tree class was interesting, but it did not allow you to specify a new
# tree with a clean user interface. Let the initializer accept a nested
# structure with hashes and arrays. You should be able to specify a tree like
# this: {'grandpa' => {'dad' => 'child 1' => {}, 'child 2' => {} }, 'uncle' =>
# {'child 3' => {}, 'child 4' => {} } } }.

puts "\n2."

class Tree
    attr_accessor :children, :node_name

    def initialize(name, children=[])
        if name.respond_to?('keys') then
            root_node = name.first
            name = root_node[0]
            children = root_node[1]
        end
        
        if children.respond_to?('keys') then
            children = children.map {|child_name, grandchildren| Tree.new(child_name, grandchildren) }
        end

        @node_name = name
        @children = children
    end

    def visit_all(&block)
        visit(&block)
        children.each {|c| c.visit_all(&block)}
    end

    def visit(&block)
        block.call self
    end
end

tree_test = Tree.new("Ruby",
    [Tree.new("Reia"),
     Tree.new("MacRuby")] )

tree_test2 = Tree.new({"Ruby" => 
    {"Reia" => {}, 
    "MacRuby" => {}}
})

tree_test.visit_all { |node| p node.node_name }
tree_test2.visit_all { |node| p node.node_name }


# 3. Write a simple grep that will print the lines of a file having any
# occurrences of a phrase anywhere in that line. you will need to do a simple
# regular expression match and read lines from a file. (This is surprisingly
# simple in Ruby.) If you want, include line numbers.

puts "\n3."

def rbgrep(pattern, filename) 
    regexp = Regexp.new(pattern)
    File.foreach(filename).with_index { |line, line_num|
        puts "#{line_num}: #{line}" if regexp =~ line
    }
end

rbgrep("guitar", "wikipedia_page.txt")
