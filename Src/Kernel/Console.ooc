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
                for(i in 0..bufferIndex)
                    buffer[i] print()
                bufferIndex = 0
                "\n>> " print()
            } else if(bufferIndex < buffer length) {
                buffer[bufferIndex] = chr
                bufferIndex += 1
            }
        }
    }
}
