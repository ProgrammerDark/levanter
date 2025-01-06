FROM archlinux
RUN pacman -Syu -y
RUN pacman -Sy git ffmpeg curl
RUN curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN pacman -Sy nodejs
RUN npm i -g yarn
RUN yarn global add pm2
RUN git clone https://github.com/lyfe00011/levanter.git /root/LyFE/
WORKDIR /root/LyFE/
RUN yarn install
CMD ["npm", "start"]
