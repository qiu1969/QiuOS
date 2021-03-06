#ifndef QIUX_IO_H_
#define QIUX_IO_H_
#include "type.h"

public
void putchar(int c);
public
unsigned int puts(const char *str);
public
void putdec(unsigned int n);
public
void puthex(int n);
public
void putoct(int n);
public
void putln();

public
int getchar();
public
int getline(char *buffer);

#endif // QIUX_IO_H_