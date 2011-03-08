# Do: 
#
# 1. Enhance the XML program to add spaces to show the indentation structure

Builder := Object clone

Builder indentLevel := 0

Builder forward := method(
    writeln(makeIndent() .. "<", call message name, ">")
    indentLevel = indentLevel + 1
    call message arguments foreach(
        arg,
        content := self doMessage(arg);
        if(content type == "Sequence", writeln(makeIndent() .. content))
    )
    indentLevel = indentLevel - 1
    writeln(makeIndent() .. "</", call message name, ">")
)

Builder makeIndent := method(
    spaces := ""
    indentLevel repeat(spaces = spaces .. "  ")
    return spaces
)

Builder ul(
            li("Io"),
            li("Lua"),
            li("JavaScript")
        )

# 2. Create a list syntax that uses brackets

# 3. Enhance the XML program to handle attributes: if the first argument is a
# map (use the curly brackets syntax), add attributes to the XML program. For
# example: book({"author": "Tate"}...) would print <book author="Tate">:

