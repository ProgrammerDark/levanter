# Use the Arch Linux base image
FROM archlinux:latest

# Install necessary packages for creating a user, setting passwords, and building AUR packages
RUN pacman -Sy --noconfirm shadow sudo git base-devel

# Create a new user 'levanter' with password 'levanter'
RUN useradd -m -G wheel -s /bin/bash levanter && \
    echo "levanter:levanter" | chpasswd

# Grant 'levanter' sudo privileges
RUN echo "levanter ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/levanter

# Switch to the 'levanter' user
USER levanter

# Set the working directory
WORKDIR /home/levanter

# Install yay
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -rf yay

# Use yay to install yt-dlp
RUN yay -S --noconfirm yt-dlp
RUN sudo pacman -S git ffmpeg curl wget nodejs npm --noconfirm
RUN sudo npm i -g yarn --noconfirm
RUN sudo npm i -g pm2 --noconfirm
RUN git clone https://github.com/lyfe00011/levanter.git /home/levanter/LyFE/
WORKDIR /home/levanter/LyFE/
RUN yarn install
CMD ["npm", "start"]
