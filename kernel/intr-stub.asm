extern default_handler
extern divide_error
extern single_step_exception
extern nmi
extern breakpoint_exception
extern overflow
extern bounds_check
extern invalid_opcode
extern coproc_not_available
extern double_fault
extern coproc_seg_overrun
extern invalid_tss
extern segment_not_present
extern stack_exception
extern general_protection

extern page_fault
extern coproc_error
extern align_check
extern machine_check
extern simd_exception

extern tss
; 外中断
extern task_schedule
extern kerboard_handler

[section .text]
global default_handler_stub
global divide_error_stub
global single_step_exception_stub
global nmi_stub
global breakpoint_exception_stub
global overflow_stub
global bounds_check_stub
global invalid_opcode_stub
global coproc_not_available_stub
global double_fault_stub
global coproc_seg_overrun_stub
global invalid_tss_stub
global segment_not_present_stub
global stack_exception_stub
global general_protection_stub

global page_fault_stub
global coproc_error_stub
global align_check_stub
global machine_check_stub
global simd_exception_stub

; 8259A外中断
global clock_intr_stub
global keyboard_intr_stub

; fault会重新执行产生异常的指令，而trap不会
default_handler_stub:
    call default_handler
    iret
divide_error_stub:
    call divide_error
    iret
single_step_exception_stub:
    call single_step_exception
    iret
nmi_stub:
    call nmi
    iret
breakpoint_exception_stub:
    call breakpoint_exception
    iret
overflow_stub:
    call overflow
    iret
bounds_check_stub:
    call bounds_check
    iret
invalid_opcode_stub:
    call invalid_opcode
    iret
coproc_not_available_stub:
    call coproc_not_available
    iret
double_fault_stub:
    call double_fault
    add esp, 4
    iret                        ; abort不会返回，可以没有iret指令
coproc_seg_overrun_stub:
    call coproc_seg_overrun
    iret
invalid_tss_stub:
    call invalid_tss
    add esp, 4
    iret
segment_not_present_stub:
    call segment_not_present
    add esp, 4
    iret
stack_exception_stub:
    call stack_exception
    add esp, 4
    iret
general_protection_stub:
    call general_protection
    add esp, 4
    iret
page_fault_stub:
    call page_fault
    add esp, 4
    iret
coproc_error_stub:
    call coproc_error
    iret
align_check_stub:
    call align_check
    add esp, 4
    iret
machine_check_stub:
    call machine_check
    iret                    ; abort不会返回，可以没有iret指令
simd_exception_stub:
    call simd_exception
    iret
clock_intr_stub:
    ; 保存现场
    sub esp, 4
    pushad
    push ds 
    push es 
    push fs 
    push gs 

    ; 修改段寄存器
    mov dx, ss 
    mov es, dx
    mov fs, dx
    mov ds, dx

    ; 将esp指向内核栈，暂时为0x7e00
    mov esp, 0x7e00

    mov al, 0x20
    out 0x20, al

    call task_schedule

    mov esp, eax
    lea eax, [esp+72]
    mov dword [tss+4], eax
    lldt [esp+76]
    pop gs
    pop fs
    pop es
    pop ds
    popad 
    add esp, 4

    iret
keyboard_intr_stub:
    call kerboard_handler
    mov al, 0x20
    out 0x20, al
    iret
