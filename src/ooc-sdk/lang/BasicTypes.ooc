include stddef, stdbool, stdint

/**
 * Pointer type
 */
Void: cover from void
Pointer: cover from void*

/**
 * character and pointer types
 */
Char: cover from char
UChar: cover from unsigned char

String: cover from char*

/**
 * integer types
 */
Int: cover from int
UInt: cover from unsigned int
Short: cover from short
UShort: cover from unsigned short
Long: cover from long
ULong: cover from unsigned long
LLong: cover from long long
ULLong: cover from unsigned long long

/**
 * fixed-size integer types
 */
Int8: cover from int8_t
Int16: cover from int16_t
Int32: cover from int32_t
Int64: cover from int64_t

UInt8:  cover from uint8_t
UInt16: cover from uint16_t
UInt32: cover from uint32_t
UInt64: cover from uint64_t

Bool: cover from bool

/**
 * real types
 */
Float: cover from float
Double: cover from double
LDouble: cover from long double

/**
 * custom types
 */
Range: cover {

    min, max: Int
    
    new: static func (.min, .max) -> This {
        this : This
        this min = min
        this max = max
        return this
    }

}

SizeT: cover from unsigned int

/**
 * objects
 */
Class: abstract class {
    
    /// Number of octets to allocate for a new instance of this class 
    instanceSize: SizeT
    
    /// Number of octets to allocate to hold an instance of this class
    /// it's different because for classes, instanceSize may greatly
    /// vary, but size will always be equal to the size of a Pointer.
    /// for basic types (e.g. Int, Char, Pointer), size == instanceSize
    size: SizeT

    /// Human readable representation of the name of this class
    name: String
    
    /// Pointer to instance of super-class
    super: const Class
    
    /// Create a new instance of the object of type defined by this class
    /*alloc: final func -> Object {
        object := gc_malloc(instanceSize) as Object
        if(object) {
            object class = this
            object __defaults__()
        }
        return object
    }
    
    inheritsFrom: final func (T: Class) -> Bool {
        if(this == T) return true
        return (super ? super as This inheritsFrom(T) : false)
    }*/

    // workaround needed to avoid C circular dependency with _ObjectClass
    __defaults__: static Func (Class)
    __destroy__: static Func (Class)
    __load__: static Func
    
}

Object: abstract class {

    class: Class
        
    /// Instance initializer: set default values for a new instance of this class
    __defaults__: func {}
    
    /// Finalizer: cleans up any objects belonging to this instance
    __destroy__: func {}

    /*instanceOf: final func (T: Class) -> Bool {
        class inheritsFrom(T)
    }*/
    
}

