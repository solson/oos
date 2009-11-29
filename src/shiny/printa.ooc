include shiny/shiny
include shiny/display

print: extern func(message: String, line: UInt) -> UInt

foo: func {
    print("test from ooc", 6)
}

