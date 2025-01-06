FROM archlinux
RUN pacman -Syu --noconfirm
RUN pacman -Sy git ffmpeg curl --noconfirm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh 
RUN pacman -Sy nodejs --noconfirm
RUN npm i -g yarn --noconfirm
RUN yarn global add pm2 --noconfirm
RUN git clone https://github.com/lyfe00011/levanter.git /root/LyFE/
WORKDIR /root/LyFE/
RUN yarn install
CMD ["npm", "start"]
