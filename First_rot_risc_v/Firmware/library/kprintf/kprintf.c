// See LICENSE.Sifive for license details.
#include <stdarg.h>
#include <stdint.h>
#include <stdbool.h>

#include <kprintf.h>

static inline void _kputs(const char *s)
{
    char c;
    for (; (c = *s) != '\0'; s++)
        kputc(c);
}

void kputs(const char *s)
{
    _kputs(s);
    kputc('\r');
    kputc('\n');
}

static void print_number(unsigned long n, bool is_signed, int width, bool zero_pad)
{
    char buffer[32];
    int i = 0;

    if (is_signed && (long)n < 0) {
        kputc('-');
        n = -(long)n;
    }

    do {
        buffer[i++] = '0' + (n % 10);
        n /= 10;
    } while (n > 0);

    while (width > i) {
        kputc(zero_pad ? '0' : ' ');
        width--;
    }

    while (i > 0) {
        kputc(buffer[--i]);
    }
}

static void print_hex(unsigned long n, int width, bool zero_pad, bool is_long)
{
    int nibbles = is_long ? (sizeof(unsigned long) * 2) : (sizeof(unsigned int) * 2);
    int significant_nibbles = 0;
    char buf[32];
    int pos = 0;
    
    for (int i = nibbles - 1; i >= 0; i--) {
        int nibble = (n >> (i * 4)) & 0xF;
        if (nibble != 0 || significant_nibbles > 0 || i == 0) {
            significant_nibbles++;
            buf[pos++] = nibble < 10 ? '0' + nibble : 'a' + nibble - 10;
        }
    }
    
    if (width > significant_nibbles) {
        int padding = width - significant_nibbles;
        while (padding-- > 0) {
            kputc(zero_pad ? '0' : ' ');
        }
    }
    
    for (int i = 0; i < significant_nibbles; i++) {
        kputc(buf[i]);
    }
}

void kprintf(const char *fmt, ...)
{
    va_list vl;
    bool is_format = false;
    bool is_long = false;
    bool is_char = false;
    int width = 0;
    bool zero_pad = false;
    char c;

    va_start(vl, fmt);
    
    while ((c = *fmt++) != '\0') {
        if (is_format) {
            if (c >= '0' && c <= '9') {
                if (c == '0' && width == 0) {
                    zero_pad = true;
                    continue;
                }
                width = width * 10 + (c - '0');
                continue;
            }

            switch (c) {
            case 'l':
                is_long = true;
                continue;
            case 'h':
                is_char = true;
                continue;
            case 'x':
                print_hex(va_arg(vl, unsigned long), width, zero_pad, is_long);
                break;
            case 'd':
            case 'u': {
                unsigned long n;
                if (is_long) {
                    n = va_arg(vl, unsigned long);
                } else {
                    n = va_arg(vl, unsigned int);
                }
                print_number(n, (c == 'd'), width, zero_pad);
                break;
            }
            case 's':
                _kputs(va_arg(vl, const char *));
                break;
            case 'c':
                kputc(va_arg(vl, int));
                break;
            default:
                kputc('%');
                kputc(c);
                break;
            }
            is_format = false;
            is_long = false;
            is_char = false;
            width = 0;
            zero_pad = false;
        } else if (c == '%') {
            is_format = true;
        } else {
            kputc(c);
        }
    }
    va_end(vl);
}