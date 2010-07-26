import Hal/[Keyboard, Display]

Console: cover {
    run: static func {
        buffer := Char[50] new()
        bufferIndex := 0
        ">> " print()
        while(true) {
            chr := Keyboard read()
            chr print()
            if(chr == '\n') {
                cmd := String new(50)
                for(i in 0..bufferIndex)
                    cmd[i] = buffer[i]
                cmd[bufferIndex] = '\0'
                handleCommand(cmd)
                bufferIndex = 0
                ">> " print()
            } else if(bufferIndex < buffer length) {
                buffer[bufferIndex] = chr
                bufferIndex += 1
            }
        }
    }

    handleCommand: static func (cmd: String) {
        cmd println()
    }
}
