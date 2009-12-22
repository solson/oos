#include <stdarg.h>
#include <stddef.h>

#define IN
#define OUT

/* Text Formatting */
#define TF_ALTERNATE 1
#define TF_ZEROPAD 2
#define TF_LEFT 4
#define TF_SPACE 8
#define TF_EXP_SIGN 16
#define TF_SMALL 32
#define TF_PLUS 64
#define TF_UNSIGNED 128

int m_printn(OUT char *str, IN int maxlen, IN int len, IN unsigned int n,
		IN int base, IN int size, IN int flags, IN int precision);
int printf(IN const char *fmt, ...);
int sprintf(OUT char *str, IN const char *fmt, ...);
int snprintf(OUT char *str, IN size_t size, IN const char *fmt, ...);
int vprintf(IN const char *fmt, va_list ap);
int vsprintf(OUT char *str, IN const char *fmt, va_list ap);
int vsnprintf(OUT char *str, IN size_t size, IN const char *fmt,
		IN va_list ap);

#define is_digit(c) ((c) >= '0' && (c) <= '9')

int m_printn(OUT char *str, IN int maxlen, IN int len, IN unsigned int n,
		IN int base, IN int size, IN int flags, IN int precision)
{
	char tmp[36], sign = '\0';
	char *digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	int i = 0;
	signed int signed_n = (signed int) n;

	/* Preprocess the flags. */

	if (flags & TF_SMALL)
		digits = "0123456789abcdefghijklmnopqrstuvwxyz";

	if (!(flags & TF_UNSIGNED) && signed_n < 0) {
		sign = '-';
		n = -signed_n;
	} else if (flags & TF_EXP_SIGN) {
		sign = '+';
	}

	if (sign)
		size--;

	if (flags & TF_ALTERNATE)
		if (base == 8) {
			if (len < maxlen)
				str[len++] = '0';
			else
				len++;
		} else if (base == 16) {
			if (len < maxlen)
				str[len++] = '0';
			else
				len++;
			if (len < maxlen)
				str[len++] = 'x';
			else
				len++;
		}

	/* Find the number in reverse. */
	if (n == 0)
		tmp[i++] = '0';
	else
		while (n != 0) {
			tmp[i++] = digits[n%base];
			n /= base;
		}

	/* Pad the number with zeros or spaces. */
	if (!(flags & TF_LEFT))
		while (size-- > i) {
			if (flags & TF_ZEROPAD)
				if (len < maxlen)
					str[len++] = '0';
				else
					len++;
			else
				if (len < maxlen)
					str[len++] = ' ';
				else
					len++;
		}

	if (sign)
		str[len++] = sign;

	/* Write any zeros to satisfy the precision. */ 
	while (i < precision--)
		if (len < maxlen)
			str[len++] = '0';
		else
			len++;

	/* Write the number. */
	while (i-- != 0) {
		size--;
		if (len < maxlen)
			str[len++] = tmp[i];
		else
			len++;
	}

	/* Left align the numbers. */
	if (flags & TF_LEFT)
		while (size-- > 0) {
			if (len < maxlen)
				str[len++] = ' ';
			else
				len++;
		}

	return len;
}

int printf(IN const char *fmt, ...)
{
	/* TODO: Make printf use memory management. */
#if 0
	char *str;
#endif
	char str[1024];
	va_list args;
	int len, i = 0;

#if 0
	va_start(args, fmt);
	len = vsnprintf(NULL, 0, fmt, args);
	va_end(args);

	str = malloc(len+1);

	va_start(args, fmt);
	len = vsnprintf(str, len+1, fmt, args);
	va_end(args);
#endif

	va_start(args, fmt);
	len = vsnprintf(str, 1024, fmt, args);
	va_end(args);

	while (str[i])
		halDisplayChar(str[i++]);

#if 0
	free(str);
#endif

	return i;
}

int sprintf(OUT char *str, IN const char *fmt, ...)
{
	va_list args;
	int i;
	
	va_start(args, fmt);
	i = vsnprintf(str, 0, fmt, args);
	va_end(args);
	
	va_start(args, fmt);
	i = vsnprintf(str, i+1, fmt, args);
	va_end(args);

	return i;
}

int snprintf(OUT char *str, IN size_t size, IN const char *fmt, ...)
{
	va_list args;
	int i;
	
	va_start(args, fmt);
	i = vsnprintf(str, size, fmt, args);
	va_end(args);
	return i;
}

int vprintf(IN const char *fmt, va_list ap)
{
	/* TODO: Make vprintf use memory management. */
#if 0
	char *str;
#endif
	char str[1024];
	va_list args;
	int len, i = 0;
	
#if 0
	len = vsnprintf(NULL, 0, fmt, ap);
	str = malloc(len+1);
	len = vsnprintf(str, len+1, fmt, ap);
#endif

	len = vsnprintf(str, 1024, fmt, ap);

	while (str[i])
		halDisplayChar(str[i++]);

#if 0
	free(str);
#endif

	return i;
}

int vsprintf(OUT char *str, IN const char *fmt, va_list ap)
{
	int i;
	
	i = vsnprintf(str, 0, fmt, ap);
	i = vsnprintf(str, i+1, fmt, ap);
	return i;
}

int vsnprintf(OUT char *str, IN size_t size, IN const char *fmt,
		IN va_list ap)
{
	int len = 0;
	const char *p;
	int flags, fieldwidth, precision, i;
	const char *sval;

	/* Leave room for the null byte. */
	if (size != 0)
		size--;

	for (p = fmt; *p; p++) {
		if (*p != '%') {
			if (len < size)
				str[len++] = *p;
			else
				len++;
			continue;
		}

		/* Find any flags. */
		flags = 0;
reset:
		switch (*++p) {
		case '#':
			flags |= TF_ALTERNATE;
			goto reset;
		case '0':
			flags |= TF_ZEROPAD;
			goto reset;
		case '-':
			flags |= TF_LEFT;
			goto reset;
		case ' ':
			flags |= TF_SPACE;
			goto reset;
		case '+':
			flags |= TF_EXP_SIGN;
			goto reset;
		}

		/* Find the field width. */
		fieldwidth = 0;
		while (is_digit(*p)) {
			if (fieldwidth > 0)
				fieldwidth *= 10;
			fieldwidth += (*p++-0x30);
		}

		/* Find the precision. */
		precision = -1;
		if (*p == '.') {
			*p++;
			precision = 0;
			if (*p == '*') {
				precision = va_arg(ap, int);
				p++;
			}
			while (is_digit(*p)) {
				if (precision > 0)
					precision *= 10;
				precision += (*p++-0x30);
			}
		}

		/* Find the length modifier. */
		if (*p == 'l' || *p == 'h' || *p == 'L') {
			p++;
		}

		flags |= TF_UNSIGNED;
		/* Find the conversion. */
		switch (*p) {
		case 'i':
		case 'd':
			flags &= ~TF_UNSIGNED;
			len = m_printn(str, size, len,
				       va_arg(ap, int), 10,
				       fieldwidth, flags, precision);
			break;
		case 'o':
			len = m_printn(str, size, len,
				       va_arg(ap, unsigned int), 8,
				       fieldwidth, flags, precision);
			break;
		case 'u':
			len = m_printn(str, size, len,
				       va_arg(ap, unsigned int), 10,
				       fieldwidth, flags, precision);
			break;
		case 'x':
			len = m_printn(str, size, len,
				       va_arg(ap, unsigned int), 16,
				       fieldwidth, flags|TF_SMALL, precision);
			break;
		case 'X':
			len = m_printn(str, size, len,
				       va_arg(ap, unsigned int), 16,
				       fieldwidth, flags, precision);
			break;
		case 'c':
			i = 0;
			if (!(flags & TF_LEFT))
				while (i++ < fieldwidth)
					if (len < size)
						str[len++] = ' ';
					else
						len++;
			if (len < size) {
				str[len++] =
					(unsigned char) va_arg(ap, int);
			} else {
				len++;
				va_arg(ap, void);
			}
			while (i++ < fieldwidth)
				if (len < size)
					str[len++] = ' ';
				else
					len++;
			break;
		case 's':
			sval = va_arg(ap, const char*);
			/* Change to -2 so that 0-1 doesn't cause the
			 * loop to keep going. */
			if (precision == -1)
				precision = -2;
			while (*sval
			       && (precision-->0 || precision <= -2))
				if (len < size) {
					str[len++] = *sval++;
				} else {
					sval++;
					len++;
				}
			break;
		case '%':
			if (len < size)
				str[len++] = '%';
			else
				len++;
			break;
		default:
			if (len < size)
				str[len++] = *p;
			else
				len++;
		}
	}

	/* And now we magically have room for one more byte. */
	if (size != 0)
		size++;

	if (len < size)
		str[len] = '\0';
	else
		if (size != 0)
			str[size] = '\0';
	return len;
}
