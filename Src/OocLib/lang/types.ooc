import Hal/[Display, Panic], Printf

include stdbool, stdint, c_types
include ./array

/**
 * objects
 */
Object: abstract class {

    class: Class

    /// Instance initializer: set default values for a new instance of this class
    __defaults__: func {}

    /// Finalizer: cleans up any objects belonging to this instance
    __destroy__: func {}

    /** return true if *class* is a subclass of *T*. */
    instanceOf: final func (T: Class) -> Bool {
        if(!this) return false
        class inheritsFrom(T)
    }
    
    /*
    toString: func -> String {
        "%s@%08p" format(class name, this)
    }
    */
}

Class: abstract class {

    /// Number of octets to allocate for a new instance of this class
    instanceSize: SizeT

    /**
     * Number of octets to allocate to hold an instance of this class
     * it's different because for classes, instanceSize may greatly
     * vary, but size will always be equal to the size of a Pointer.
     * for basic types (e.g. Int, Char, Pointer), size == instanceSize
     */
    size: SizeT

    /// Human readable representation of the name of this class
    name: String

    /// Pointer to instance of super-class
    super: const Class

    /// Create a new instance of the object of type defined by this class
    alloc: final func ~_class -> Object {
        object := gc_malloc(instanceSize) as Object
        if(object) {
            object class = this
        }
        return object
    }

    inheritsFrom: final func ~_class (T: Class) -> Bool {
        if(this == T) return true
        return (super ? super inheritsFrom(T) : false)
    }

}

Array: cover from _lang_array__Array {
    length: extern Int
    data: extern Pointer
}

/**
 * Pointer type
 */
Void: cover from void
Pointer: cover from void* {
    toString: func -> String { "%p" format(this) }
}

NULL: unmangled Pointer = 0

/**
 * character and pointer types
 */
//__char: extern(char) Void
__char_ary: extern(__CHAR_ARY) Void
Char: cover from char {
    /// check for an alphanumeric character
    alphaNumeric?: func -> Bool {
        alpha?() || digit?()
    }

    /// check for an alphabetic character
    alpha?: func -> Bool {
        lower?() || upper?()
    }

    /// check for a lowercase alphabetic character
    lower?: func -> Bool {
        this >= 'a' && this <= 'z'
    }

    /// check for an uppercase alphabetic character
    upper?: func -> Bool {
        this >= 'A' && this <= 'Z'
    }

    /// check for a decimal digit (0 through 9)
    digit?: func -> Bool {
        this >= '0' && this <= '9'
    }

    /// check for a hexadecimal digit (0 1 2 3 4 5 6 7 8 9 a b c d e f A B C D E F)
    hexDigit?: func -> Bool {
        digit?() ||
        (this >= 'A' && this <= 'F') ||
        (this >= 'a' && this <= 'f')
    }

    /// check for a control character
    control?: func -> Bool {
        (this >= 0 && this <= 31) || this == 127
    }

    /// check for any printable character except space
    graph?: func -> Bool {
        printable?() && this != ' '
    }

    /// check for any printable character including space
    printable?: func -> Bool {
        this >= 32 && this <= 126
    }

    /// check for any printable character which is not a space or an alphanumeric character
    punctuation?: func -> Bool {
        printable?() && !alphaNumeric?() && this != ' '
    }

    /** check for white-space characters: space, form-feed ('\f'), newline ('\n'),
        carriage return ('\r'), horizontal tab ('\t'), and vertical tab ('\v') */
    whitespace?: func -> Bool {
        this == ' '  ||
        this == '\f' ||
        this == '\n' ||
        this == '\r' ||
        this == '\t' ||
        this == '\v'
    }

    /// check for a blank character; that is, a space or a tab
    blank?: func -> Bool {
        this == ' ' || this == '\t'
    }
    
    /// convert to an integer. This only works for digits, otherwise -1 is returned
    toInt: func -> Int {
        if (digit?()) {
            return (this - '0') as Int
        }
        return -1
    }

    /// return the lowered charater
    toLower: func -> This {
        if(this upper?()) {
            return this - 'A' + 'a'
            // or this + 32 ?
        }
        return this
    }

    /// return the capitalized character
    toUpper: func -> This {
        if(this lower?()) {
            return this - 'a' + 'A'
            // or this - 32 ?
        }
        return this
    }

    /// return a one-character string containing this character
    toString: func -> String {
        String new(this)
    }

    /// print this character without a following newline
    print: func {
        Display printChar(this)
    }

    /// print this character with a following newline
    println: func {
        Display printChar(this)
        Display printChar('\n')
    }
}

SChar: cover from signed char extends Char
UChar: cover from unsigned char extends Char

String: cover from Char* {
    /** Create a new string exactly *length* characters long (without the nullbyte).
        The contents of the string are undefined. */
    new: static func~withLength (length: Int) -> This {
        result := gc_malloc(length + 1) as This
        result[length] = '\0'
        result
    }

    /// Create a new string of the length 1 containing only the character *c*
    new: static func~withChar (c: Char) -> This {
        result := This new~withLength(1)
        result[0] = c
        result
    }
    
    /// return the string's length, excluding the null byte.
    length: func -> SizeT {
        i := 0
        while (this@) {
            this += 1
            i += 1
        }
        return i
    }

    println: func {
        println(this)
    }

    print: func {
        print(this)
    }

    /** return a string formatted using *this* as template. */
    format: func (...) -> This {
        list:VaList

        va_start(list, this)

        length := vsnprintf(null, 0, this, list)
        output := This new(length)
        va_end(list)

        va_start(list, this)
        vsnprintf(output, length + 1, this, list)
        va_end(list)

        return output
    }

    printf: func (...) {
        list: VaList

        va_start(list, this)
        vprintf(this, list)
        va_end(list)
    }

    printfln: func (...) {
        list: VaList

        va_start(list, this)
        vprintf(this, list)
        va_end(list)
        '\n' print()
    }
}

/**
 * integer types
 */
__void: extern(void) Void
__int: extern(int) Void
__uint: extern(uint32_t) Void

Long: cover from signed long {
    toString:    func -> String { "%ld" format(this) }
    toHexString: func -> String { "%lx" format(this) }

    odd?:  func -> Bool { this % 2 == 1 }
    even?: func -> Bool { this % 2 == 0 }

    in?: func(range: Range) -> Bool {
        return this >= range min && this < range max
    }

    /// check if the specified `bit` is 1
    bitSet?: func (bit: UInt) -> Bool {
        (this & (1 << bit)) as Bool
    }

    /// check if the specified `bit` is 0
    bitClear?: func (bit: UInt) -> Bool {
        (~this & (1 << bit)) as Bool
    }

    /// set the specified `bit` to 1
    bitSet: func (bit: UInt) -> This {
        this | (1 << bit)
    }

    /// clear the specified `bit` to 0
    bitClear: func (bit: UInt) -> This {
        this & ~(1 << bit)
    }

    /// returns `this` aligned to the next boundary of `alignment`.
    align: func (alignment: This) -> This {
        if(this % alignment == 0)
            return this
        else
            return (this & ~(alignment - 1)) + alignment
    }
}

Int:   cover from signed int   extends Long
Short: cover from signed short extends Long

ULong: cover from unsigned long extends Long {
    toString: func -> String { "%lu" format(this) }
}

UInt:   cover from unsigned int   extends ULong
UShort: cover from unsigned short extends ULong

/**
 * fixed-size integer types
 */
Int8:  cover from int8_t  extends Long
Int16: cover from int16_t extends Long
Int32: cover from int32_t extends Long
Int64: cover from int64_t extends Long

UInt8:  cover from uint8_t  extends ULong
UInt16: cover from uint16_t extends ULong
UInt32: cover from uint32_t extends ULong
UInt64: cover from uint64_t extends ULong

SizeT: cover from size_t extends ULong

Bool: cover from bool {
    toString: func -> String { this ? "true" : "false" }
}

/**
 * real types
 */
LDouble: cover from long double {
    toString: func -> String {
        "%.2Lf" format(this)
    }

    abs: func -> This {
        return this < 0 ? -this : this
    }
}

Float: cover from float extends LDouble
Double: cover from double extends LDouble

/**
 * custom types
 */
Range: cover {
    min, max: Int

    new: static func (.min, .max) -> This {
        this: This
        this min = min
        this max = max
        return this
    }
}

/**
* exceptions
*/
Exception: class {

    origin: Class
    msg: String

    init: func ~originMsg (=origin, =msg) {}
    init: func ~noOrigin (=msg) {}

    getMessage: func -> String {
        if(origin)
            return "[%s in %s]: %s\n" format(this as Object class name, origin name, msg)
        else
            return "[%s]: %s\n" format(this as Object class name, msg)
    }

    throw: func {
        panic(getMessage())
    }

}

/**
 * Closures
 */
Closure: cover {
    thunk:   Pointer
    context: Pointer
}
