# Find:
#   Some Io example problems
#       http://www.iolanguage.com/about/samplecode/
#
#   An Io community that will answer questions
#       http://tech.groups.yahoo.com/group/iolanguage/messages
#       http://stackoverflow.com/questions/tagged/iolanguage
#       #io on freenode
#       http://www.reddit.com/r/iolanguage
#
#   A style guide with Io idioms
#       http://en.wikibooks.org/wiki/Io_Programming/Io_Style_Guide
#
# Answer:
#
# 1. Evaluate 1 + 1 and then 1 + "one". Is Io strongly typed or weakly typed?
#
#   Strongly typed. Trying to run `1 + "one"` throws an exception that says:
#       "Exception: argument 0 to method '+' must be a Number, not a 'Sequence'"
#   
# 2. Is 0 true or false? What about the empty string? Is nil true or false?

if(0) println   # true
if("") println  # true
if(nil) println # false

# 3. How can you tell what slots a prototype supports?
# <prototype> slotNames

Zerg := Object clone
Zerg sixPool := "Zergling rush!"
Zerg slotNames println  # will print list(type, sixPool)

# 4. What is the difference between = (equals), := (colon equals), and ::=
# (colon colon equals)? When would you use each one?
#
# =     is used to assign something to an existing slot
# :=    is used to assign something to a previously non-existent slot
# ::=   is used to assign something to a previously non-existent slot as well as
#       create a setter for that slot
#   
#   iolanguage.com's guide puts this much much better than I did:
#
# ::= 	Creates slot, creates setter, assigns value
# := 	Creates slot, assigns value
# = 	Assigns value to slot if it exists, otherwise raises exception 
#
#
# Do:
#
# 1. Run an Io program from a file.
#
# From the command line run: io day1.io
#

"successfully ran day1" println

# 2.Execute the code in a slot given its name.
#
# I'm not quite sure I understood this question. I'll answer the two
# interpretations I could come up with.
#
# If the code in a slot is stored as a method then just invoking the slot is
# enough:

Zerg macroItUp := method("Injecting larvae now!" println)
Zerg macroItUp # Will print "Injecting larvae now!"

# If the code in a slot is stored as a string then you should use something like
# doString:

Zerg macroHarderSteps := ("\"Spreading creep now!\" println")
Zerg macroHarder := method(doString(Zerg macroHarderSteps))
Zerg macroHarder

# Update: Re-reading this now the intent of the question seems obvious! Write a
# method that, given a method name, will try to execute that method.
"\nLet's try that again" println
Zerg specifyMacro := method(name, perform(name))
Zerg specifyMacro("macroItUp")
Zerg specifyMacro("macroHarder")
"Done!" println
