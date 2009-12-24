#!/bin/sh

./debug.sh >/dev/null 2>&1 &
gdb --symbols=Src/Kernel/oos.exe -ex 'target remote :1234' $@

