#ifndef QIUOS_PROC_H_
#define QIUOS_PROC_H_
#include "type.h"

typedef struct 
{
    uint32_t gs;    // 仅使用低16位
    uint32_t fs;
    uint32_t es;
    uint32_t ds;
    uint32_t edi;
    uint32_t esi;
    uint32_t ebp;
    uint32_t esp;
    uint32_t ebx;
    uint32_t edx;
    uint32_t ecx;
    uint32_t eax;
    uint32_t retaddr;
    uint32_t eip;
    uint32_t cs;
    uint32_t eflags;
    uint32_t esp;
    uint32_t ss;   
}register_frame;



#endif // QIUOS_PROC_H_