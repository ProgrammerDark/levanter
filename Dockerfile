FROM quay.io/lyfe00011/md:beta
WORKDIR /root/LyFE/
COPY . .
RUN yarn install
CMD ["npm", "start"]