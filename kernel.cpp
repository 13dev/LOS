//
// Created by Leonardo Oliveira on 08/01/2020.
//

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
    static unsigned short* VideoMemory = (unsigned short*)0xb8000;

    for(int i = 0; str[i] != '\0'; ++i)
    {
        // Copy the high bytes of VideMemory and combine with str byte
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];
    }

}
//Entry Point for the kernel
extern "C" void KernelEntryPoint(void* multiboot_struct, unsigned int magic_number)
{
    printf("Kernel Entry Point");

    while(true);
}

