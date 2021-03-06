#include "proc.h"
#include "global.h"
#include "const.h"
#include "gdt.h"
#include "../include/string.h"


public 
void task_schedule(const intr_frame *frame UNUSED)
{
    current_proc++;
    if(current_proc >= tasks+4)
        current_proc = tasks;
}

public
process * create_process(process_func proc_main)
{
    static pid_t next_pid = 0;
    process * proc = &tasks[next_pid];
    
    proc->pid = next_pid;
    proc->priority = 0;
    proc->sel_ldt = SEL_LDT;
    proc->registers.cs = (0 << 3) + SA_RPL3 + SA_TIL;
    proc->registers.ds = proc->registers.es = proc->registers.ss = proc->registers.fs = (1 << 3) + SA_RPL3 + SA_TIL;
    proc->registers.gs = (2 << 3) + SA_RPL3 + SA_TIL;
    proc->registers.eflags = IOPL3_FLAG|INTR_FLAG|MBS_FLAG;
    proc->registers.esp = (uint32_t)(stack[next_pid])+1024;
    proc->registers.eip = (uint32_t)proc_main;

    proc->p_tty = &_tty;
    next_pid++;
    return proc;
}

public
void reset_msg(message * msg)
{
    memset(msg, 0, sizeof(message));
}

private 
void block(process * proc)
{
    task_schedule((const intr_frame *)proc);
}

private
void unblock(process * proc)
{

}

public 
int msg_receive(process * current, int src, message * msg)
{

} 

public
int msg_send(process * current, int dest, message * msg)
{

}
