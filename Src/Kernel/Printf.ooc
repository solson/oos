/*
 Copyright (c) 2010 Nick Markwell
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

import Hal/Display
//printf: extern proto func (fmt: const String, ...) -> Int
//vprintf: extern proto func (fmt: const String, ap: VaList) -> Int

/* Text Formatting */
tf_alternate:= 1
tf_zeropad:= 2
tf_left:= 4
tf_space:= 8
tf_exp_sign:= 16
tf_small:= 32
tf_plus:= 64
tf_unsigned:= 128

m_printn: func ( str: String, maxlen: Int, len: Int, n: UInt,
                base: Int, size: Int, flags: Int, precision: Int ) -> Int
{
  tmp: Char[36]
  sign: Char = '\0'
  digits := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  i := 0
  signed_n := n as Int

  /* Preprocess the flags. */

  if (flags & tf_small)
    digits = "0123456789abcdefghijklmnopqrstuvwxyz"

  if (!(flags & tf_unsigned) && signed_n < 0) {
    sign = '-'
    n = -signed_n
  } else if (flags & tf_exp_sign) {
    sign = '+'
  }

  if (sign)
    size-=1

  if (flags & tf_alternate)
    if (base == 8) {
      if (len < maxlen) {
        str[len] = '0'
      }
      len+=1
    } else if (base == 16) {
      if (len < maxlen) {
        str[len] = '0'
      }
      len+=1

      if (len < maxlen) {
        str[len] = 'x'
      }
      len+=1
    }

  /* Find the number reverse. */
  if (n == 0) {
    tmp[i] = '0'
    i+=1
  } else {
    while (n != 0) {
      tmp[i] = digits[n%base]
      i+=1
      n /= base
    }
  }

  /* Pad the number with zeros or spaces. */
  if (!(flags & tf_left)) {
    while (size > i) {
      if (flags & tf_zeropad) {
        if (len < maxlen) {
          str[len] = '0'
        }
        len+=1
      } else {
        if (len < maxlen) {
          str[len] = ' '
        }
        len+=1
      }
      size-=1
    }
  }
    

  if (sign) {
    str[len] = sign
    len+=1
  }

  /* Write any zeros to satisfy the precision. */
  while (i < precision) {
    if (len < maxlen) {
      str[len] = '0'
    }
    len+=1
    precision-=1
  }

  /* Write the number. */
  while (i != 0) {
    size-=1
    if (len < maxlen) {
      str[len] = tmp[i];
    }
    len+=1
    i-=1
  }

  /* Left align the numbers. */
  if (flags & tf_left) {
    while (size > 0) {
      if (len < maxlen) {
        str[len] = ' '
      }
      len+=1
      size-=1
    }
  }

  return len
}

printf: func ( fmt: String, ... ) -> Int
{
  /* TODO: Make printf use memory management. */
/*
  char *str;
*/
  //Char str[1024]
  str: String = "" // Uninitialized ftl
  args: VaList
  len: Int
  i: Int = 0

/*
  va_start(args, fmt)
  len = vsnprintf(null, 0, fmt, args)
  va_end(args)

  str = malloc(len+1)

  va_start(args, fmt)
  len = vsnprintf(str, len+1, fmt, args)
  va_end(args)
*/

  va_start(args, fmt)
  len = vsnprintf(str, 1024, fmt, args)
  va_end(args)

  while (str[i]) {
    printChar(str[i])
    i+=1
  }

/*
  free(str)
*/

  return i
}

sprintf: func ( str: String, fmt: String, ... ) -> Int
{
  args: VaList
  i: Int

  va_start(args, fmt)
  i = vsnprintf(str, 0, fmt, args)
  va_end(args)

  va_start(args, fmt)
  i = vsnprintf(str, i+1, fmt, args)
  va_end(args)

  return i
}

snprintf: func ( str: String, size: SizeT, fmt: String, ... ) -> Int
{
  args: VaList
  i: Int

  va_start(args, fmt)
  i = vsnprintf(str, size, fmt, args)
  va_end(args)
  return i
}

vprintf: func ( fmt: String, ap: VaList ) -> Int
{
  /* TODO: Make vprintf use memory management. */
/*
  char *str;
*/
  //char str[1024];
  str: String = "" // What, uninitialized? Roar.
  //args: VaList // I'm not sure what this was for anyways, but it may be important
  len: Int
  i: Int = 0

/*
  len = vsnprintf(null, 0, fmt, ap)
  str = malloc(len+1)
  len = vsnprintf(str, len+1, fmt, ap)
*/

  len = vsnprintf(str, 1024, fmt, ap)

  while (str[i]) {
    printChar(str[i])
    i+=1
  }

/*
  free(str)
*/

  return i
}

vsprintf: func ( str: String, fmt: String, ap: VaList) -> Int
{
  i: Int

  i = vsnprintf(str, 0, fmt, ap)
  i = vsnprintf(str, i+1, fmt, ap)
  return i
}

vsnprintf: func ( str: String, size: SizeT, fmt: String,
              ap: VaList) -> Int
{
  len: Int = 0
  p: Char*
  //int flags, fieldwidth, precision, i;
  flags, fieldwidth, precision, i: Int
  breakloop: Int = 0 // There is likely a much prettier way to do this
  sval: Char*

  /* Leave room for the null byte. */
  if (size != 0)
    size-=1

  for (p = fmt; p@; p+=1) {
    if (p@ != '%') {
      if (len < size) {
        str[len] = p@
      }
      len+=1
      continue
    }
  }

    /* Find any flags. */
    flags = 0
/*reset:
    p+=1
    switch (p@) {
    case '#':
      flags |= tf_alternate;
      goto reset;
    case '0':
      flags |= tf_zeropad;
      goto reset;
    case '-':
      flags |= tf_left;
      goto reset;
    case ' ':
      flags |= tf_space;
      goto reset;
    case '+':
      flags |= tf_exp_sign;
      goto reset;
    }*/

    // There is likely a much prettier way to do this
  while(1) {
    match (p@) {
      case '#' =>
        flags |= tf_alternate
      case '0' =>
        flags |= tf_zeropad
      case '-' =>
        flags |= tf_left
      case ' ' =>
        flags |= tf_space
      case '+' =>
        flags |= tf_exp_sign
      case =>
        breakloop=1
    }
    p+=1
    if (breakloop == 1)
      break
  }

  /* Find the field width. */
  fieldwidth = 0
  while (p@ isDigit()) {
    if (fieldwidth > 0)
      fieldwidth *= 10
    fieldwidth += (p@-0x30);
    p@+=1
  }

  /* Find the precision. */
  precision = -1
  if (p@ == '.') {
    p@+=1
    precision = 0
    if (p@ == '*') {
      precision = va_arg(ap, __int);
      p+=1
    }
    while (p@ isDigit()) {
      if (precision > 0)
        precision *= 10
      precision += (p@-0x30)
      p@+=1
    }
  }

  /* Find the length modifier. */
  if (p@ == 'l' || p@ == 'h' || p@ == 'L') {
    p+=1
  }

  flags |= tf_unsigned
  /* Find the conversion. */
  match (p@) {
    case 'i' =>
    case 'd' =>
      flags &= ~tf_unsigned
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
               fieldwidth, flags|tf_small, precision)
    case 'X' =>
      len = m_printn(str, size, len,
               va_arg(ap, __uint), 16,
               fieldwidth, flags, precision)
    case 'c' =>
      i = 0;
      if (!(flags & tf_left)) {
        while (i < fieldwidth) {
          if (len < size) {
            str[len] = ' '
          }
          len+=1
          i+=1
        }
      }
      if (len < size) {
        str[len] = va_arg(ap, __int) as UChar
      } else {
        va_arg(ap, __void)
      }
      len+=1
      while (i < fieldwidth) {
        if (len < size)
          str[len] = ' '
        len+=1
        i+=1
      }
    case 's' =>
      sval = va_arg(ap, __char_ary) as Pointer
      /* Change to -2 so that 0-1 doesn't cause the
       * loop to keep going. */
      if (precision == -1)
        precision = -2
      while (sval@ && ((precision-1)>0 || precision <= -2))
        if ( (precision - 1) > 0 ) {
          precision-=1
        }
        if (len < size) {
          str[len] = sval@
        }
        sval+=1
        len+=1
    case '%' =>
      if (len < size) {
        str[len] = '%'
      }
      len+=1
    case =>
      if (len < size)
        str[len] = p@
      len+=1
  }

  /* And now we magically have room for one more byte. */
  if (size != 0)
    size+=1;

  if (len < size)
    str[len] = '\0'
  else
    if (size != 0)
      str[size] = '\0'
  return len
}
