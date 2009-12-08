import BasicTypes

// variable arguments
//version(gcc) {
VaList: cover from __builtin_va_list
__builtin_va_start: extern func (VaList, ...) // ap, last_arg
__builtin_va_arg: extern func (VaList, ...) // ap, type
__builtin_va_end: extern func (VaList) // ap
//}

sizeof: extern func (...) -> SizeT
