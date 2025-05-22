sudo dnf update -y && sudo dnf autoremove -y
reboot

# Enable RPMFusion repos: https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager --enable fedora-cisco-openh264
sudo dnf update @core

# If secure boot
sudo dnf install kmodtool akmods mokutil openssl
sudo kmodgenca -a
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
reboot # on reboot, enroll MOK keys

## Install Proprietory Nvidia Drivers: https://rpmfusion.org/Howto/NVIDIA
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
reboot # on reboot nvidia driver will be used instead of nouveau

# Media editors, tools & utilities. @multimedia drivers for playing variety of video and audio formats: https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
sudo dnf install @multimedia vlc gimp audacity kdenlive remmina yt-dlp thunderbird libreoffice solaar 

# Build essentials
sudo dnf install @development-tools @c-development @system-tools @admin-tools gcc-c++ cmake python3-devel # for specific python version like python3.12, use python3.12-devel

# WINE
sudo dnf install wine winetricks md5sum wine64 wine-mono mingw32-wine-gecko mingw64-wine-gecko bottles