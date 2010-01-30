// variable arguments
//version(gcc) {
VaList: cover from __builtin_va_list
va_start: extern(__builtin_va_start) func (VaList, ...) // ap, last_arg
va_arg: extern(__builtin_va_arg) func (VaList, ...) // ap, type
va_end: extern(__builtin_va_end) func (VaList) // ap
va_copy: extern(__builtin_va_copy) func (VaList, VaList) // dest, src
//}

sizeof: extern func (...) -> SizeT

