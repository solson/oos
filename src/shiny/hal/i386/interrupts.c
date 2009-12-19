void halInterruptsEnable(void)
{
    __asm__ __volatile__ ("sti");
}

void halInterruptsDisable(void)
{
    __asm__ __volatile__ ("cli");
}

