OOC := rock
CC := gcc
QEMU := qemu-system-i386

CCFLAGS := +-m32 +-nostdinc +-ffreestanding +-fno-stack-protector
OOCFLAGS := -c -v -g --sdk=sdk --sourcepath=src --gc=off --nomain --cstrings -Iinclude --$(CC) $(CCFLAGS)

LDFLAGS := -melf_i386 -nostdlib -g
ASFLAGS := -felf32 -g

STAGE2 := /boot/grub/stage2_eltorito

OOCFILES := $(shell find "src" -name "*.ooc")
ASMFILES := $(shell find "src" -name "*.asm")
ASMOBJFILES := $(patsubst %.asm,%.o,$(ASMFILES))

.PHONY: all clean bochs bochs-dbg qemu

all: oos.iso

bochs: oos.iso
	@bochs -qf .bochsrc

bochs-dbg: oos.iso
	@bochs -qf .bochsrc-dbg

qemu: oos.iso
	@$(QEMU) -cdrom $< -net none

oos.iso: oos.exe isofs/boot/grub/stage2_eltorito isofs/boot/grub/menu.lst
	@mkdir -p isofs/system
	cp $< isofs/system
	genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table -input-charset utf-8 -o $@ isofs

oos.exe: ${ASMOBJFILES} src/oos.lib
	${LD} ${LDFLAGS} -T src/linker.ld -o $@ ${ASMOBJFILES} src/oos.lib

src/oos.lib: ${OOCFILES}
	${OOC} ${OOCFLAGS} --entrypoint=kmain --staticlib=$@ boot/main.ooc

%.o: %.asm
	nasm ${ASFLAGS} -o $@ $<

isofs/boot/grub/stage2_eltorito:
	mkdir -p isofs/boot/grub
	cp ${STAGE2} $@

clean:
	 $(RM) -r $(wildcard $(ASMOBJFILES) src/oos.lib oos.exe oos.iso rock_tmp ooc_tmp build .libs)
