; 一个假的常量
has_err_code    equ 0

; 全局变量
extern intr_handlers
extern current_proc
extern tss 

; 有错误码的异常桩
; exception_stub(int vec_no, has_err_code);
%macro exception_stub 2
    call save

    call [intr_handlers+4*%1]
    mov esp, [esp]

    pop gs 
    pop fs 
    pop es 
    pop ds 
    popad

    add esp, 8
    iret
%endmacro

; 没有错误码的异常桩
; exception_stub(int vec_no);
%macro exception_stub 1
    push %1                     ; 将中断号压栈

    call save

    call [intr_handlers+4*%1]
    ; mov esp, [esp]              ; 将esp指向要调度进程intr_frame的起始位置, 这里还是原来的进程

    call start_process

%endmacro

[section .data]
global intr_stubs
intr_stubs:
    dd divide_error_stub            ; 0
    dd single_step_exception_stub   ; 1
    dd nmi_stub                     ; 2
    dd breakpoint_exception_stub    ; 3
    dd overflow_stub                ; 4
    dd bounds_check_stub            ; 5
    dd invalid_opcode_stub          ; 6
    dd coproc_not_available_stub    ; 7
    dd double_fault_stub            ; 8
    dd coproc_seg_overrun_stub      ; 9
    dd invalid_tss_stub             ;10
    dd segment_not_present_stub     ;11
    dd stack_exception_stub         ;12
    dd general_protection_stub      ;13
    dd page_fault_stub              ;14
    dd 0                            ;15 intel保留为使用
    dd coproc_error_stub            ;16
    dd align_check_stub             ;17
    dd machine_check_stub           ;18
    dd simd_exception_stub          ;19
    
times 256*4 - ($-intr_stubs) dd 0   ; 全部置为0

[section .text]
global start_process

; 异常桩
divide_error_stub:          exception_stub 0
single_step_exception_stub: exception_stub 1
nmi_stub:                   exception_stub 2
breakpoint_exception_stub:  exception_stub 3
overflow_stub:              exception_stub 4
bounds_check_stub:          exception_stub 5
invalid_opcode_stub:        exception_stub 6
coproc_not_available_stub:  exception_stub 7
double_fault_stub:          exception_stub 8, has_err_code
coproc_seg_overrun_stub:    exception_stub 9
invalid_tss_stub:           exception_stub 10, has_err_code
segment_not_present_stub:   exception_stub 11, has_err_code
stack_exception_stub:       exception_stub 12, has_err_code
general_protection_stub:    exception_stub 13, has_err_code
page_fault_stub:            exception_stub 14, has_err_code
coproc_error_stub:          exception_stub 16
align_check_stub:           exception_stub 17, has_err_code
machine_check_stub:         exception_stub 18
simd_exception_stub:        exception_stub 19



offset_of_retaddr   equ 48
; 保存现场
; 重新设置esp，并push之前的esp
save:
    pushad
    push ds 
    push es 
    push fs 
    push gs 

    mov esi, esp
    mov esp, 0x7c00
    push esi

    mov ax, ss 
    mov ds, ax 
    mov es, ax 
    mov fs, ax 

    jmp [esi+offset_of_retaddr]
    
; void start_process(process * proc);
start_process:
    mov esp, [esp+4]
    lldt [esp + 80]
    lea eax, [esp+76]
    mov dword [tss+4], eax
restart:    ; 调用前先将esp指向PCB的开始位置
    pop gs 
    pop fs 
    pop es 
    pop ds 
    popad

    add esp, 8
    iretd