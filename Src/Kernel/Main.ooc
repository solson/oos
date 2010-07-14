import Kernel, Multiboot, Hal/[Hal, Display, Panic, MM], Bochs

kmain: func (mb: MultibootInfo*, magic: UInt32) {
    multiboot = mb@
    Hal setup()

    "This kernel is written in " print()
    Display setFgColor(Color lightGreen, ||
        "ooc" print()
    )
    "!\n\n" print()

    "Boot Loader:  " print()
    Display setFgColor(Color lightBlue, ||
        multiboot bootLoaderName as String println()
    )
    
    "Command Line: " print()
    Display setFgColor(Color lightBlue, ||
        multiboot cmdline as String println()
    )
    '\n' print()

    "Kernel Start: %p" printfln(kernelStart&)
    "Kernel End:   %p" printfln(kernelEnd&)
    "Kernel Size:  %i kB" printfln((kernelEnd& as Int - kernelStart& as Int) / 1024)
    '\n' print()

    "Total Memory: %6i kB" printfln(MM memorySize / 1024)
    "Used Memory:  %6i kB" printfln(MM usedMemory / 1024)
    "Free Memory:  %6i kB" printfln(MM getFreeMemory() / 1024)
    '\n' print()

    "This is " print()
    Display setFgColor(Color lightRed, ||
        "a super cool " print()
        Display setFgColor(Color red, ||
            "example of " print()
        )
        "the new " print()
        Display setBgColor(Color magenta, ||
            "setFgColor and setBgColor" print()
        )
        " functions." print()
    )

    while(true){}
}
