void enableInterrupts(void)
{
    __asm__ __volatile__ ("sti");
}

void disableInterrupts(void)
{
    __asm__ __volatile__ ("cli");
}
