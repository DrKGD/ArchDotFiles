# Deatharte .dotfiles

## Manual steps 
The following was written following this [https://www.atlassian.com/git/tutorials/dotfiles](guide).
```bash
# Clone repo
cd ~
git clone --bare https://github.com/DrKGD/ArchDotFiles 

# Alias for ease of use
alias dotfiles='/usr/bin/git --git-dir=$HOME/.ArchDotFiles/ --work-tree=$HOME'

# Checkout
dotfiles checkout ArchDotFiles
```

**Warning**
> It won't checkout if there are existing files that conflicts with those of the repository!

## TODO(s)
- [ ] Application config(s)
	- [x] Editor (nvim)
	- [ ] Terminal (wezterm)
	- [ ] PDF Viewer (sioyek)
	- [x] Screen Compositor (picom)
	- [x] Status line (polybar)
	- [ ] Greater (ssdm)
	- [x] DE (i3)
		- [x] Keybindings
		- [x] Workspaces 
		- [x] Local-to-device configuration 
	- [x] Music Player (mpd, ncmpcpp)
	- [x] Scripts
- [ ] Source(d) files
	- [x] .zshrc (zsh login shell configuration)
	- [x] .alias, .env (custom aliases and global envs)
	- [x] .p10k.zsh (powerlevel10k configuration)

## Installation and Configuration guide

### Prepare ISO
Grab the latest [ISO](https://archlinux.org/download/) and an USB with enough capacity.

```bash
# Look for the USB drive name, ensuring it is not mounted (MOUNTPOINTS field has to be empty)
lsblk
fdisk -l

# In case it is mounted
sudo umount /mount/point

# Copy image onto the device (not the partition!)
cp /path/to/image /dev/ice
# or dd bs=4M if=/path/to/image of=/dev/ice status=progress && sync
```

**Note**
> Possibly use other [commands](https://wiki.archlinux.org/title/USB_flash_installation_medium)

### First steps
Boot up the computer using the USB stick as primary drive, arch installation should popup at this point.

1. Format the installation disk 
```bash
# If not sure about which disk
lsblk 

# The disks marked with 1 in the ROTA field are mechanical (= not ssds)
lsblk -d -o name, rota

# Format the disk
fdisk /dev/ice

# Delete existing partitions 
fdisk# d

# Create at least three partition, +1g means one gigabyte from the starting position
# 1gb								EFI
# RAM + SQRT(RAM)		SWAP
#										PRIMARY PARTITION
fdisk# n 

# Change type of partition
# 1  								EFI
# 19             		SWAP
#	UNCHANGED					PRIMARY PARTITION
fdisk# t

# Write changes and exit utility
fdisk# w
fdisk# exit

# Format partitions
# EFI
mkfs.fat -F 32 /dev/ice1

# SWAP
mkswap /dev/ice2
swapon /dev/ice2

# PRIMARY PARTITION
mkfs.ext4 /dev/ice3
```

2. Ensure internet connectivity (not required if in wired ethernet connection).
Use `iwctl` utility to get a connection up and running.
```bash
# Run utility
iwctl

# Get all devices
iwd# device list

# Retrieve all available networks
iwd# station [device] scan
iwd# station [device] get-networks

# Connect (password prompt)
iwd# station [device] connect [network]
```

3. Bootstrap the linux installation.
Will be installing the following packages `base linux linux-firmware` and either `intel-ucode` or `amd-ucode`.
```bash
# Mount the PRIMARY PARTITION onto /mnt
mount /dev/ice3 /mnt

# Pacstrap the base packages
pacstrap /mnt base linux linux-firmware vim git [intel/amd-ucode]

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
```

4. Finalize base installation 

- Timezone and System clock
Set timezone and system clock.
```bash
## Set zone
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

## Set hwclock
hwclock --systohc
```

- Locale
Add/Uncomment these lines in the `/etc/locale.gen`
```
en_US.UTF-8 UTF-8
it_IT.UTF-8 UTF-8
```

Configure `/etc/locale.conf`
```
LANG="en_US.UTF-8"
LC_MEASUREMENTS="it_IT.UTF-8"
LC_TIME="it_IT.UTF-8"
LC_PAPER="it_IT.UTF-8"
```
	
Then generate the new locale `locale-gen`.

- Hostname
Add `[DEVICE]-DRKGD` to `/etc/hostname` and
```
127.0.0.1	localhost
::1				localhost
127.0.1.1	[DEVICE]-DRKGD.localdomain [DEVICE]-DRKGD	
```

- Add user, update permissions.
Update root password with `passwd`, then add a new user
```bash
useradd -m [NAME]
passwd [NAME]
usermod [NAME] -aG wheel,audio,video,storage
```

Uncomment `/etc/sudoers` to enable any wheel user to use sudo commands (with password prompt)
```
%wheel ALL=(ALL:ALL) ALL
```

- Install grub
```bash
yes | pacman -S grub efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
mount /dev/ice1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg
```

**Note**
If this is a dualboot system, enable prober in `/etc/default/grub` by commenting this line
```
#GRUB_DISABLE_OS_PROBER=false
```

Then re-run `grub-mkconfig`
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

- Install reflector and enable service

Edit reflector parameters in `/etc/xdg/reflector/reflector.conf`
```bash
# Save to mirrorlist file
--save /etc/pacman.d/mirrorlist

# German mirrors only, as Italian mirrors are sluggish 
--country GB,DE 

# Sort last 5 by speed and age
--latest 10 
--age 12
--sort rate

# Use https and ipv4
--protocol https
--ipv4
```

Fix reflector service (wait until has connection), by adding this line in `/usr/lib/systemd/system/reflector.service`
```bash
ExecStartPre=/bin/bash -c 'until ping -c1 google.com; do sleep 1; done'
```

Update mirrors once, enable service (n.b. cannot run it in live install), then update packages
```bash
reflector --save /etc/pacman.d/mirrorlist --country GB,DE --protocol https --ipv4 --latest 10 --age 12 --sort rate
systemctl enable reflector.service
pacman --noconfirm -Syu
```

- Install base packages
```bash
pacman --noconfirm --needed -S \
	git gcc base-devel linux-headers python python-pip nodejs make ntfs-3g \
	bluez networkmanager network-manager-applet dialog wpa_supplicant \
	xdg-utils xdg-user-dirs pulseaudio alsa-utils \
	xclip cifs-utils wget
```

... and enable these services
```bash
systemctl enable reflector.service
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable fstrim.timer
```

- Kill the bell
Uncomment `set bell-style none` in `/etc/inputrc`

- Initial ramdisk 
Run `mkinitcpio -p linux`


- Fstab, mount drives

```bash
# Make the following folders
# fdrive/archive		ntfs-3g long term, local storage
# nas								network storage
# ram								ram drive
mkdir /mnt/fdrive
mkdir /mnt/nas
mkdir /mnt/ram

# Add NAS credentials in /root/.smbcredentials
username=[user]
password=[pass]

# Then add the following lines into `/etc/fstab`
# RAM Disk
tmpfs		/mnt/ram		tmpfs			nosuid,nodev,noatime,size=1g,mode=1777,rw			0 0

# Remount everything with
sudo mount -a

# Verify with
findmnt
```

**TODO**
This part is incomplete, please consider finishing it.

- Setup previously defined user
```bash
# Login into user
su [NAME]

# Generate default XDG-Directories
xdg-user-dirs-update

# Disable xdg autoupdate in `/home/[NAME]/.config/user-dirs.dir`
enabled=false

# Replace folders with symbolic links (Movies, Music, tmp_download)
ln -s /mnt/fdrive/[folder] /home/[NAME]/[folder]

# Finally update configuration
xdg-user-dirs-update
```

- Reboot the machine with `shutdown -r now`

### After the reboot 
- Install paru
```bash
pac
man --needed --noconfirm -S rust base-devel git 
git clone https://aur.archlinux.org/paru.git /tmp/paru/
cd /tmp/paru/
makepkg -si
```

- Install drivers 
	- Laptop (xorg) (intel)
	```bash
	# For laptop (intel) (xorg)
	sudo pacman -S --needed --noconfirm mesa xorg-server
	```

	- Desktop
	**TODO**

- Prepare desktop environment
	- Wezterm			as terminal emulator (paru)
	- Neovim			as editor (paru)
	- Sioyek			as pdf viewer (paru)
	- i3-gaps			as window manager (paru)
	- sddm				as greater
	- firefox 		as browser
	- meh-git			as image viewer (paru)
	- mpd					as audio server
	- ncmpcpp 		as audio client
	- mpv					as video player
	- picom   		as compositor
	- dmenu				as launcher
	- neofetch		as rice memer
	- xwallpaper	to set wallpapers
	- shutter			to take screenshots
	- [missing]		as file browser 
	- rg, fd			as file finder and grep finder
	- zsh         as shell

	```bash
	yes | paru -S --needed --noconfirm wezterm-nightly-bin neovim-nightly-bin sioyek i3-gaps \
		sddm firefox meh-git mpd ncmpcpp mpv picom dmenu neofetch xwallpaper shutter ripgrep fd zsh
	```

- Additional packages in other package managers, required for the system 
	- nvim 
	```bash
	# python support
	python -m pip install --user --upgrade pynvim
	```

	- wezterm
	```bash
	# install ohmyzsh
	sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

	# install powerlevel through aur
	paru -S zsh-theme-powerlevel10k-git

	# install fonts
		ttf-scientifica
	```

