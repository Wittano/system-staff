#!/bin/bash
# Helpful to read output when debugging
set -x

# Stop display manager
systemctl stop display-manager.service gdm.service
## Uncomment the following line if you use GDM
#killall gdm-x-session

# Unbind VTconsoles
echo 0 >/sys/class/vtconsole/vtcon0/bind

# Unbind EFI-Framebuffer
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/unbind

sudo modprobe -r nvidia_uvm
sudo modprobe -r nvidia_drm
sudo modprobe -r nvidia_modeset
sudo modprobe -r nvidia

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_01_00_0
virsh nodedev-detach pci_0000_01_00_1

modprobe vfio_iommu_type1
modprobe vfio_pci
modprobe vfio_virqfd
modprobe vfio_pci_core

