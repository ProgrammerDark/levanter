FROM archlinux
RUN pacman -Syu --noconfirm
RUN pacman -S git ffmpeg curl --noconfirm
RUN pacman -S nodejs --noconfirm
RUN npm i -g yarn --noconfirm
RUN yarn global add pm2 --noconfirm
RUN git clone https://github.com/lyfe00011/levanter.git /root/LyFE/
WORKDIR /root/LyFE/
RUN yarn install
CMD ["npm", "start"]
