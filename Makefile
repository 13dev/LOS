# sudo apt-get install g++ binutils libc6-dev-i386
# sudo apt-get install VirtualBox grub-legacy xorriso
#tell to compiler there's no have std lib
GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = loader.o kernel.o

%.o: %.cpp
	g++ $(GPPPARAMS) -o $@ -c $<

%.o: %.s
	as $(ASPARAMS) -o $@ $<

# create file kernel.bin, depends of linker.ld and objects
kernel.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

install: kernel.bin
	sudo cp $< /boot/kernel.bin


kernel.iso: kernel.bin
	rm -rf iso/
	rm -rf $@
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp $< iso/boot/
	echo "set timeout=0" >> iso/boot/grub/grub.cfg
	echo "set default=0" >> iso/boot/grub/grub.cfg
	echo 'menuentry "LOS" {' >> iso/boot/grub/grub.cfg
	echo "multiboot /boot/kernel.bin" >> iso/boot/grub/grub.cfg
	echo "boot" >> iso/boot/grub/grub.cfg
	echo "}" >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso/