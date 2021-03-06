#ifndef QIUX_STDIO_H_
#define QIUX_STDIO_H_

#define STDIN_FILENO 0
#define STDOUT_FILENO 1

#include "type.h"

#define va_start(LIST, ARG) __builtin_va_start(LIST, ARG)
#define va_end(LIST) __builtin_va_end(LIST)
#define va_arg(LIST, TYPE) __builtin_va_arg(LIST, TYPE)
#define va_copy(DST, SRC) __builtin_va_copy(DST, SRC)

/* Standard functions. */
public
size_t printf(const char *, ...) PRINTF_FORMAT(1, 2);
public
size_t vsnprintf(char *, size_t, const char *, va_list) PRINTF_FORMAT(3, 0);
public
size_t snprintf(char *, size_t, const char *, ...) PRINTF_FORMAT(3, 4);

public
void panic(const char *fmt, ...);

#endif // QIUX_STDIO_H_