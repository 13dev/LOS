# set magic number to bootloader recognize as a kernel
.set MAGIC, 0x1badb002
.set FLAGS, (1 << 0 | 1 << 1)
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .text

# Defined in kernel.cpp
.extern KernelEntryPoint
.extern CallConstructors

# Entry Point
.global loader


loader:
    # set esp register to kernel_stack
    mov $kernel_stack, %esp
    call CallConstructors
    push %eax
    push %ebx
    call KernelEntryPoint

# infinite loop
_stop:
    cli
    hlt
    jmp _stop

.section .bss
# 2MiB
.space 2*1024*1024

kernel_stack:
