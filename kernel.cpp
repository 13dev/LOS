//
// Created by Leonardo Oliveira on 08/01/2020.
//
#include "types.h"

typedef void (*constructor)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;
extern "C" void CallConstructors()
{
    for(constructor* i = &start_ctors; i != &end_ctors; i++)
        (*i)();
}


void printf(char* str)
{
    //Specific video memory to write text on screen
    static uint16_t* VideoMemory = (uint16_t*)0xb8000;

    for(int i = 0; str[i] != '\0'; ++i)
    {
        // Copy the high bytes of VideMemory and combine with str byte
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];
    }

}
//Entry Point for the kernel
extern "C" void KernelEntryPoint(void* multiboot_struct, uint32_t magic_number)
{
    printf("Kernel Entry Point");

    // do not close it
    while(true);
}

