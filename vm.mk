CUT = /usr/bin/cut
EXTLINUX = /usr/bin/extlinux
GENFSTAB = /usr/bin/genfstab
GREP = /usr/bin/grep
HEAD = /usr/bin/head
MKFS_EXT4 = /usr/bin/mkfs.ext4
MKDIR = /usr/bin/mkdir
MOUNT = /usr/bin/mount
PACSTRAP = /usr/bin/pacstrap
RMDIR = /usr/bin/rmdir
QEMU_IMG = /usr/bin/qemu-img
SED = /usr/bin/sed
UMOUNT = /usr/bin/umount

vm_file = test/archlinux.raw
vm_file_size = 1G
vm_mount_point = $(CURDIR)/test/vm

vm_first_file = $(vm_mount_point)/lost+found
vm_pacstrap_file = $(vm_mount_point)/home
vm_fstab = $(vm_mount_point)/etc/fstab
vm_extlinux_file = $(vm_mount_point)/boot/ldlinux.sys
vm_extlinux_configuration = $(vm_mount_point)/boot/extlinux.conf

.PHONY: vm
vm: | clean-vm-file $(vm_extlinux_configuration)
	@echo not yet done
	false

$(vm_file): clean-vm-mount
	$(QEMU_IMG) create -f raw $@ $(vm_file_size)
	$(MKFS_EXT4) -F $(vm_file)

$(vm_first_file): $(vm_file) $(vm_mount_point) clean-vm-mount
	$(MOUNT) $(vm_file) $(vm_mount_point)

$(vm_pacstrap_file): $(vm_first_file)
	$(PACSTRAP) $(vm_mount_point) base

$(vm_fstab): $(vm_pacstrap_file)
	$(GENFSTAB) -U $(vm_mount_point) >> $(vm_fstab)
	$(SED) -i -e 's#$(vm_mount_point)#/#' $(vm_fstab)

$(vm_extlinux_file): $(vm_fstab)
	$(EXTLINUX) --install $(vm_mount_point)/boot

$(vm_extlinux_configuration): $(vm_extlinux_file)
	echo 'DEFAULT archlinux' >> $@
	echo 'LABEL archlinux' >> $@
	echo 'SAY Booting Arch Linux' >> $@
	echo 'LINUX /boot/vmlinuz-linux' >> $@
	echo 'APPEND root=/dev/disk/by-uuid/$(shell $(GREP) '^UUID=' $(vm_fstab) | $(HEAD) -n 1 | $(CUT) -c 6-41) ro' >> $@
	echo 'INITRD /boot/initramfs-linux.img' >> $@

$(vm_mount_point):
	$(MKDIR) $@

.PHONY: clean-vm
clean-vm: clean-vm-file clean-vm-mount-point

.PHONY: clean-vm-file
clean-vm-file: clean-vm-mount
	if [ -e $(vm_file) ]; then \
		$(RM) $(vm_file) || exit $$?; \
	fi

.PHONY: clean-vm-mount-point
clean-vm-mount-point: clean-vm-mount
	if [ -e $(vm_mount_point) ]; then \
		$(RMDIR) $(vm_mount_point) || exit $$?; \
	fi

.PHONY: clean-vm-mount
clean-vm-mount:
	if [ -e $(vm_first_file) ]; then \
		$(UMOUNT) $(vm_mount_point) || exit $$?; \
	fi
