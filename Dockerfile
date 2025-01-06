FROM archlinux
RUN pacman -Syu --no-confirm
RUN pacman -Sy git ffmpeg curl --no-confirm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh 
RUN pacman -Sy nodejs --no-confirm
RUN npm i -g yarn --no-confirm
RUN yarn global add pm2 --no-confirm
RUN git clone https://github.com/lyfe00011/levanter.git /root/LyFE/
WORKDIR /root/LyFE/
RUN yarn install
CMD ["npm", "start"]
