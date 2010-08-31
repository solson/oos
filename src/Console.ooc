import devices/[Keyboard, Display], memory/MM

Console: cover {
    run: static func {
        buffer: Char[50]
        bufferIndex := 0
        ">> " print()
        while(true) {
            chr := Keyboard read()
            if(chr == '\n') {
                '\n' print()
                cmd := String new(50)
                for(i in 0..bufferIndex)
                    cmd[i] = buffer[i]
                cmd[bufferIndex] = '\0'
                handleCommand(cmd)
                bufferIndex = 0
                ">> " print()
            } else if(chr == '\b') {
                if(bufferIndex > 0) {
                    bufferIndex -= 1
                    "\b \b" print()
                }
            } else if(bufferIndex < 50) {
                chr print()
                buffer[bufferIndex] = chr
                bufferIndex += 1
            }
        }
    }

    handleCommand: static func (cmd: String) {
        match cmd {
            case "memory" =>
                "Total Memory: %6i kB" printfln(MM memorySize / 1024)
                "Used Memory:  %6i kB" printfln(MM usedMemory / 1024)
                "Free Memory:  %6i kB" printfln(MM freeMemory / 1024)
        }
    }
}

operator == (lhs, rhs: String) -> Bool {
    if ((lhs == null) || (rhs == null)) {
        return false
    }

    rhslen := rhs length()
    if (lhs length() != rhslen) {
        return false
    }

    s1 := lhs as Char*
    s2 := rhs as Char*
    for (i in 0..rhslen) {
        if (s1[i] != s2[i]) {
            return false
        }
    }
    return true
}
