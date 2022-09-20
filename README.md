# Deatharte configuration 

### TODO(s)
- [ ] Ricing (aesthetics)
	- [ ] Dmenu
	- [ ] Rofi
	- [x] File Manager (thunar)
	- [x] Archive File Manager (peazip)
	- [ ] Greater (sddm)
	- [x] PDF Viewer (sioyek)
	- [ ] Music Player (mpd, ncmpcpp)
		- [x] mpd
		- [ ] ncmpcpp
	- [x] DE (i3)
		- [ ] Conky
		- [ ] Polybar
		- [x] Keybindings
		- [x] Workspaces 
		- [x] Local-to-device configuration 
	- [x] Awesome-wm 
		- [ ] Wibar(s)
		- [ ] Widget(s)
		- [ ] Keybindings
		- [x] Workspaces 
		- [ ] Local-to-device configuration 
- [x] Development environment
	- [x] Editor (nvim)
	- [x] Terminal emulator (wezterm)
- [x] Screen Compositor (picom)

# Fast start 
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

# Installation and Configuration guide

## Installation ISO 
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

## Steps 
Boot up the computer using the USB stick as primary drive, arch installation should popup at this point.

### Format the installation disk 
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
# UNCHANGED					PRIMARY PARTITION
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

## Ensure internet connectivity (not required if in wired ethernet connection)
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

## Bootstrap the linux installation.
Will be installing the following packages `base linux linux-firmware` and either `intel-ucode` or `amd-ucode`.
```bash
# Mount the PRIMARY PARTITION onto /mnt
mount /dev/ice3 /mnt

# Pacstrap the base packages
pacstrap /mnt base linux linux-firmware vim git [intel/amd-ucode]

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
```

## Finalize installation
### Install and configure reflector
Install reflector
```bash
pacman --noconfirm reflector
```

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

Update mirrors once, enable service (n.b. cannot run it in live install), then update packages
```bash
reflector --save /etc/pacman.d/mirrorlist --country GB,DE --protocol https --ipv4 --latest 10 --age 12 --sort rate
pacman --noconfirm -Syu
```

### Install base and required packages
```bash
pacman --noconfirm --needed -S \
git gcc base-devel linux-headers python python-pip nodejs make ntfs-3g \
bluez bluez-utils networkmanager network-manager-applet dialog wpa_supplicant \
xdg-user-dirs pulseaudio alsa-utils \
xclip cifs-utils wget
```

... and enable these services (care not to enable reflector.service but reflector.timer instead!)
```bash
systemctl enable reflector.timer
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable fstrim.timer
```

### Set hostname 
Add `[DEVICE]-DRKGD` to `/etc/hostname` and the following configuration to `/etc/hosts`
```
127.0.0.1	localhost
::1				localhost
127.0.1.1	[DEVICE]-DRKGD.localdomain [DEVICE]-DRKGD	
```

### Set timezone and system clock.
```bash
## Set zone
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

## Set hwclock
hwclock --systohc
timedatectl set-ntp true
```

### Setup locale(s)
Add/Uncomment these lines in the `/etc/locale.gen`
```
en_US.UTF-8 UTF-8
it_IT.UTF-8 UTF-8
```

Configure `/etc/locale.conf`
```
LANG="en_US.UTF-8"
LC_MEASUREMENTS="it_IT.UTF-8"
LC_TIME="en_US.UTF-8"
LC_PAPER="it_IT.UTF-8"
```

Then generate the new locale `locale-gen`.


### Install grub and configure mkinitcpio
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

Finally, run `mkinitcpio -p linux`

### Create user, update permissions and configure user folders.
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

Configure user folders (xdg)
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

### Mount drives using fstab 
```bash
# Make the following folders
# fdrive/archive		ntfs-3g long term, local storage
# nas								network storage
# ram								ram drive
mkdir /mnt/ram
mkdir /mnt/nas
mkdir /mnt/fdrive

Then add the following lines into `/etc/fstab`
# RAM Disk
tmpfs		/mnt/ram		tmpfs			nosuid,nodev,noatime,size=1g,mode=1777,rw			0 0

# Archive  
get uuid with lsblk -f then
UUID=[UUID] /mnt/fdrive ntfs-3g		rw,auto,users,exec,nls=utf8,umask=003,gid=46,uid=1000	0	0

# NAS
# Credentials in /root/.smbcredentials
username=[user]
password=[pass]

# Remount everything with
sudo mount -a

# Verify with
findmnt
```

## Optional step(s)
### Connect to wifi
```
nmcli device wifi rescan
nmcli device wifi list
nmcli device wifi connect SSID --ask
```

### Kill the bell for errors
Uncomment `set bell-style none` in `/etc/inputrc`

## Aftermath 
At this point, if everything was done correctly, you should reboot and finish off the installation.
Reboot the machine with `shutdown -r now`, then take off from there.

### Install driver(s)
#### Laptop
Laptop could use wayland, but I'd rather have one configuration for all the devices.
```bash
# (xorg) (intel)
sudo pacman -S --needed --noconfirm mesa xorg-server
```

#### Desktop
WIP: 


### Install paru
```bash
pac
man --needed --noconfirm -S rust base-devel git 
git clone https://aur.archlinux.org/paru.git /tmp/paru/
cd /tmp/paru/
makepkg -si
```

### Prepare Desktop Environment 
- `wezterm`	as terminal emulator (aur)
- `nvim` as editor (aur)
- `sioyek` as pdf viewer (aur)
- `i3-gaps` as a tiling window manager (aur)
- `polybar` as status (if using i3)
- `awesome-git` as a tiling window manager (aur)
- `sddm` as greater
- `firefox` as browser (also firefox-developer)
- `meh-git` as image viewer (aur)
- `mpd` as audio server
- `ncmpcpp` as audio client
- `mpv` as video player
- `picom` as compositor
- `dmenu`, `rofi`	as launcher(s)
- `neofetch` as a professional rice memer
- `feh` to set wallpapers
- `maim` to take screenshots
- `thunar` as file browser, also requires 
	- `gvfs`, `gvfs-smb`, 
	- `ffmpegthumbnailer`, 
	-	`tumbler`, `tumbler-extra-thumbnailers`, `raw-thumbnailer`, 
	- `thunar-archive-plugin`, `thunar-media-tags-plugin`, `thunar-shares-plugin`, `thunar-volman`
- `rg`, `fd` as file finder and grep finder
- `zsh` as shell
- `blueman` as a GUI bluetooth manager
- `lxappearance` to configure themes.
- `gzdoom` for the daily recommended dose of doom
- `alttab-git` a fast utility to alt-tab between applications
- `qbittorrent` as torrent client
- `handlr-regex` as a xdg-utils replacement (default applications)
- `peazip` as an archive file manager
- tools
	- `gimp`, image editor
	- `pandoc`, document converter
	-	`ascii-image-converter-git` (aur), converts images to ascii
	- `nodejs-live-server` (aur)
	- `texlive-most`, latex compilation
	- `jq`, grep-like commands for json 
	- `python-pip`
	- `telegram`
	- `graphicsmagick`, `wmctrl`
	- `cups`, `system-config-printer`, `hplip` to use the network hp printer 
- fonts 
	- `ttf-scientifica`
	- `ttf-nerd-fonts-symbols-mono`
```bash
yes | paru -S --needed --noconfirm wezterm-nightly-bin neovim-nightly-bin sioyek i3-gaps awesome-git \
	sddm firefox firefox-developer-edition meh-git mpd ncmpcpp mpv picom dmenu polybar neofetch feh wmctrl graphicsmagick \
	thunar gvfs gvfs-smb maim ripgrep fd zsh rofi gimp ffmpegthumbnailer tumbler tumbler-extra-thumbnailers raw-thumbnailer thunar-archive-plugin thunar-media-tags-plugin thunar-shares-plugin thunar-volman \
	telegram python-pip handlr-regex xdg-utils-handlr \
	cups system-config-printer hplip \
	ttf-scientifica ttf-nerd-fonts-symbols-mono \
	peazip-qt-bin \
	alttab-git lxappearance ascii-image-converter-git nodejs-live-server

sudo systemctl enable sddm
```

### Final steps

We should now install non-pacman packages.
#### nvim 
```bash
# python support
python -m pip install --user --upgrade pynvim
```

#### firefox
Add SSB profile to `$HOME/.mozilla/firefox/.profiles.ini` use application in single window browser mode. 
```
[Profile3]
Name=SSB
IsRelative=1
Path=static.SSB
```

#### thunar
Allow thumbnails everywhere `Edit > Preferences > Display > Show thumbnails "Always"`
Restart thunar with `thunar -q` if you don't notice any change.

#### i3, sddm
Configure sddm to use custom script to launch i3 instead, `/usr/share/xsessions/i3.desktop`
```bash
Exec=/bin/sh -c "$HOME/.config/i3/.$HOSTNAME"
```

#### awesome, sddm
Configure sddm to use custom script to launch awesome instead, `/usr/share/xsessions/awesome.desktop`
```bash
Exec=/bin/sh -c "$HOME/.config/awesome/.$HOSTNAME"
```

#### sudoers
Configure `/etc/sudoers` on global allowed scripts, if required
```
deatharte ALL=(ALL) ALL
deatharte ALL=(root) NOPASSWD: /home/deatharte/.config/awesome/shell/(script.sh)
```

#### polybar
```bash
# gpustat for gpu informations (nvidia only)
pip install gpustat
```

#### ohmyzsh
```bash
# install ohmyzsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# install powerlevel through aur
paru -S zsh-theme-powerlevel10k-git
```

#### lxappearance
Handle themes for qt4/gtk oriented applications
Note: To update current theme you are sometimes required to restart sddm (`sudo systemctl sddm restart`).

#### gzdoom
Get [WADS](https://archive.org/details/2020_03_22_DOOM) from here 👀, won't be including in here for copyright reasons!

#### github
Configure a key for github
```bash
ssh-keygen -b 2048 -t rsa
```

Then copy `id_rsa.pub` content in [github](www.github.com/settings.keys).

Finally, configure machine git globals
```bash
git config --global user.name NAME
git config --global user.email EMAIL
```

### Peripherals management and screens setup 
#### TES68 (keyboard)
Save a file with the following content into /etc/udev/hwdb.d/90-custom-keyboard.hwdb
```bash
evdev:input:b0003v1EA7p0002*
KEYBOARD_KEY_70039=leftctrl
KEYBOARD_KEY_700e4=kp0
KEYBOARD_KEY_700e0=rightctrl
```

#### HP LaserJet M129-M134
Install `cups`, `hplip` and `system-config-printer`. Launch `system-config-printer`, add the printer and configure.
***NOTE*** It uses A4 Paper, not letter format!

#### Monitors (desktop only) Desktop screens
As the screens are not in the same order as the gpu recognises them, we need to set them up with xrand.
First and foremost, add a file `/etc/sddm.conf`
```bash
	[XDisplay]
	DisplayCommand=/usr/share/sddm/scripts/Xsetup
```

Of course, we also need the Xsetup file as well (the three monitors and the)
```
#!/bin/sh/

xrandr --output DVI-I-1 --rate 144.00 --mode 1920x1080 --primary
xrandr --output DP-1 --rate 60.00 --mode 1920x1080 --left-of DVI-I-1
xrandr --output DVI-D-0 --rate 60.00 --mode 1920x1080 --right-of DVI-I-1
xrandr --output HDMI-0 --rate 60.00 --mode 1920x1080 --right-of DVI-I-1
```

It is preferable to enable force full-composition pipeline in nvidia-settings on non-primary monitors.


# Additional guide(s) and memo(s)
## Keyboard event remapping
Using this [https://askubuntu.com/questions/742946/how-to-find-the-hwdb-header-of-a-general-input-device](guide).
1. Find device vendor id using lsusb (they are written as vendor:product), e.g. `1ea7`
1. Run `find /sys -name *modalias | xargs grep -i $vendor`, replace `$vendor` with previous output. Look up for shorter output. Its modalias should _probably_ start with `input:b` (not sure).
e.g. `/sys/devices/pci0000:00/0000:00:01.2/0000:20:00.0/0000:21:08.0/0000:2a:00.1/usb1/1-2/1-2.1/1-2.1:1.1/0003:1EA7:0002.000E/input/input45/modalias:input:b0003v1EA7p0002e0110-e0,3,kra28,mlsfw`
1. Look at `MSG_SCAN` field using the `evtest` command (requires sudo). For example, tab is `7002b`.
1. Push a new file `/etc/udev/hwdb.d/90-custom-keyboard.hwdb` which has the following content (n.d.r. copy the _b-string_ until `e`)
```bash
evdev:input:b0003v1EA7p0002*
KEYBOARD_KEY_7002b=leftctrl
```
