/*
 Copyright (c) 2010 Nick Markwell and Scott Olson
 Copyright (c) 2009 Martin Brandenburg

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
*/

import devices/Display

/* Text Formatting */
TF_ALTERNATE := 1 << 0
TF_ZEROPAD   := 1 << 1
TF_LEFT      := 1 << 2
TF_SPACE     := 1 << 3
TF_EXP_SIGN  := 1 << 4
TF_SMALL     := 1 << 5
TF_PLUS      := 1 << 6
TF_UNSIGNED  := 1 << 7

m_printn: func (str: String, maxlen, len: Int, n: UInt, base, size, flags, precision: Int) -> Int {
    sign: Char = '\0'
    tmp: Char[36]
    digits := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    i := 0
    signed_n := n as Int

    /* Preprocess the flags. */

    if(flags & TF_ALTERNATE && base == 16) {
        str[len] = '0'
        if(flags & TF_SMALL)
            str[len + 1] = 'x'
        else
            str[len + 1] = 'X'
        len += 2
    }

    if(flags & TF_SMALL)
        digits = "0123456789abcdefghijklmnopqrstuvwxyz"

    if(!(flags & TF_UNSIGNED) && signed_n < 0) {
        sign = '-'
        n = -signed_n
    } else if(flags & TF_EXP_SIGN) {
        sign = '+'
    }

    if(sign)
        size -= 1

    /* Find the number in reverse. */
    if(n == 0) {
        tmp[i] = '0'
        i += 1
    } else {
        while(n != 0) {
            tmp[i] = digits[n % base]
            i += 1
            n /= base
        }
    }

    /* Pad the number with zeros or spaces. */
    if(!(flags & TF_LEFT))
        while(size > i) {
            size -= 1
            if(flags & TF_ZEROPAD) {
                if(len < maxlen) {
                    str[len] = '0'
                    len += 1
                } else {
                    len += 1
                }
            } else {
                if(len < maxlen) {
                    str[len] = ' '
                    len += 1
                } else {
                    len += 1
                }
            }
        }

    if(sign) {
        str[len] = sign
        len += 1
    }

    /* Write any zeros to satisfy the precision. */
    while(i < precision) {
        precision -= 1
        if(len < maxlen) {
            str[len] = '0'
            len += 1
        } else {
            len += 1
        }
    }

    /* Write the number. */
    while(i != 0) {
        i -= 1
        size -= 1
        if(len < maxlen) {
            str[len] = tmp[i]
            len += 1
        } else {
            len += 1
        }
    }

    /* Left align the numbers. */
    if(flags & TF_LEFT)
        while(size > 0) {
            size -= 1
            if(len < maxlen) {
                str[len] = ' '
                len += 1
            } else
                len += 1
        }

    return len
}

printf: func (fmt: String, ...) -> Int {
    str: String
    args: VaList
    len: Int

    va_start(args, fmt)
    len = vsnprintf(NULL, 0, fmt, args)
    va_end(args)

    str = gc_malloc(len+1)

    va_start(args, fmt)
    len = vsnprintf(str, len+1, fmt, args)
    va_end(args)

    str print()

    free(str)

    return len
}

sprintf: func (str: String, fmt: String, ...) -> Int {
    args: VaList
    i: Int

    va_start(args, fmt)
    i = vsnprintf(str, 0, fmt, args)
    va_end(args)

    va_start(args, fmt)
    i = vsnprintf(str, i + 1, fmt, args)
    va_end(args)

    return i
}

snprintf: func (str: String, size: SizeT, fmt: String, ...) -> Int {
    args: VaList
    i: Int

    va_start(args, fmt)
    i = vsnprintf(str, size, fmt, args)
    va_end(args)
    return i
}

vprintf: func (fmt: String, ap: VaList) -> Int {
    str: String
    len: Int

    len = vsnprintf(NULL, 0, fmt, ap)
    str = gc_malloc(len+1)
    len = vsnprintf(str, len+1, fmt, ap)

    str print()

    free(str)

    return len
}

vsprintf: func (str: String, fmt: String, ap: VaList) -> Int {
    i: Int

    i = vsnprintf(str, 0, fmt, ap)
    i = vsnprintf(str, i + 1, fmt, ap)
    return i
}

vsnprintf: func (str: String, size: SizeT, fmt: String, ap: VaList) -> Int {
    len := 0
    p: Char*
    flags, fieldwidth, precision, i: Int
    sval: Char*

    /* Leave room for the null byte. */
    if(size != 0)
        size -= 1

    p = fmt
    while(p@) {
        if(p@ != '%') {
            if(len < size) {
                str[len] = p@
            }
            len += 1
            p += 1
            continue
        }

        /* Find any flags. */
        flags = 0

        while(true) {
            p += 1
            match(p@) {
                case '#' => flags |= TF_ALTERNATE
                case '0' => flags |= TF_ZEROPAD
                case '-' => flags |= TF_LEFT
                case ' ' => flags |= TF_SPACE
                case '+' => flags |= TF_EXP_SIGN
                case => break
            }
        }

        /* Find the field width. */
        fieldwidth = 0
        while(p@ digit?()) {
            if(fieldwidth > 0)
                fieldwidth *= 10
            fieldwidth += (p@ - 0x30)
            p += 1
        }

        /* Find the precision. */
        precision = -1
        if(p@ == '.') {
            p += 1
            precision = 0
            if(p@ == '*') {
                precision = va_arg(ap, __int)
                p += 1
            }
            while(p@ digit?()) {
                if (precision > 0)
                    precision *= 10
                precision += (p@ - 0x30)
                p += 1
            }
        }

        /* Find the length modifier. */
        if(p@ == 'l' || p@ == 'h' || p@ == 'L') {
            p += 1
        }

        flags |= TF_UNSIGNED
        /* Find the conversion. */
        match(p@) {
            case 'i' =>
                flags &= ~TF_UNSIGNED
                len = m_printn(str, size, len,
                                 va_arg(ap, __int), 10,
                                 fieldwidth, flags, precision)
            case 'd' =>
                flags &= ~TF_UNSIGNED
                len = m_printn(str, size, len,
                                 va_arg(ap, __int), 10,
                                 fieldwidth, flags, precision)
            case 'o' =>
                len = m_printn(str, size, len,
                                 va_arg(ap, __uint), 8,
                                 fieldwidth, flags, precision)
            case 'u' =>
                len = m_printn(str, size, len,
                                 va_arg(ap, __uint), 10,
                                 fieldwidth, flags, precision)
            case 'x' =>
                len = m_printn(str, size, len,
                                 va_arg(ap, __uint), 16,
                                 fieldwidth, flags|TF_SMALL, precision)
            case 'X' =>
                len = m_printn(str, size, len,
                                 va_arg(ap, __uint), 16,
                                 fieldwidth, flags, precision)
            case 'p' =>
                flags |= TF_ALTERNATE
                flags |= TF_SMALL
                len = m_printn(str, size, len,
                                 va_arg(ap, __uint), 16,
                                 fieldwidth, flags, precision)
            case 'c' =>
                i = 0
                if(!(flags & TF_LEFT))
                    while(i < fieldwidth) {
                        i += 1
                        if(len < size) {
                            str[len] = ' '
                            len += 1
                        } else {
                            len += 1
                        }
                    }
                if(len < size) {
                    str[len] = va_arg(ap, __int) as UChar
                    len += 1
                } else {
                    len += 1
                    va_arg(ap, __void)
                }
                while(i < fieldwidth) {
                    i += 1
                    if (len < size) {
                        str[len] = ' '
                        len += 1
                    } else {
                        len += 1
                    }
                }
            case 's' =>
                sval = va_arg(ap, __char_ary) as Pointer
                /* Change to -2 so that 0-1 doesn't cause the
                 * loop to keep going. */
                if(precision == -1)
                    precision = -2
                while(sval@ && (precision > 0 || precision <= -2)) {
                    if(precision > 0) {
                        precision -= 1
                    }
                    if(len < size) {
                        str[len] = sval@
                        len += 1
                        sval += 1
                    } else {
                        sval += 1
                        len += 1
                    }
                }
            case '%' =>
                if(len < size) {
                    str[len] = '%'
                    len += 1
                } else {
                    len += 1
                }
            case =>
                if(len < size) {
                    str[len] = p@
                    len += 1
                } else {
                    len += 1
                }
        }
        p += 1
    }

    /* And now we magically have room for one more byte. */
    if(size != 0)
        size += 1

    if(len < size)
        str[len] = '\0'
    else if(size != 0)
        str[size] = '\0'
    return len
}
