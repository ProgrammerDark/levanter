const {
  bot,
  getBuffer,
  addAudioMetaData,
  yts,
  generateList,
} = require('../lib/');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const ytIdRegex =
  /(?:http(?:s|):\/\/|)(?:(?:www\.|)youtube(?:\-nocookie|)\.com\/(?:watch\?.*(?:|\&)v=|embed|shorts\/|v\/)|youtu\.be\/)([-_0-9A-Za-z]{11})/;

function getCookiesFilePath() {
  const cookiesFilePath = process.env.COOKIES_FILE;
  if (!cookiesFilePath) {
    throw new Error('COOKIES_FILE is not defined in the .env file');
  }
  return `--cookies ${cookiesFilePath}`;
}

bot(
  {
    pattern: 'ytv ?(.*)',
    desc: 'Download youtube video',
    type: 'download',
  },
  async (message, match) => {
    match = match || message.reply_message.text;
    if (!match) return await message.send('_Example : ytv url_');

    if (!ytIdRegex.test(match))
      return await message.send('*Give me a yt link!*', {
        quoted: message.data,
      });

    const vid = ytIdRegex.exec(match)[1];
    const outputPath = path.resolve(__dirname, `../downloads/${vid}.mp4`);
    const cookiesFlag = getCookiesFilePath();

    // Execute yt-dlp command to download video with cookies
    exec(`yt-dlp ${cookiesFlag} -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4 --output "${outputPath}" "https://www.youtube.com/watch?v=${vid}"`, async (error, stdout, stderr) => {
      if (error) {
        console.error(`Error: ${error.message}`);
        return await message.send('*Failed to download video.*', {
          quoted: message.data,
        });
      }

      // Send downloaded video
      await message.sendFromFile(outputPath, { quoted: message.data });
      
      // Cleanup
      fs.unlinkSync(outputPath);
    });
  }
);

bot(
  {
    pattern: 'yta ?(.*)',
    desc: 'Download youtube audio',
    type: 'download',
  },
  async (message, match) => {
    match = match || message.reply_message.text;
    if (!match) return await message.send('_Example : yta url_');

    const vid = ytIdRegex.exec(match)[1];
    const outputPath = path.resolve(__dirname, `../downloads/${vid}.mp3`);
    const cookiesFlag = getCookiesFilePath();

    // Execute yt-dlp command to download audio with cookies
    exec(`yt-dlp ${cookiesFlag} -f bestaudio[ext=m4a]/bestaudio --output "${outputPath}" "https://www.youtube.com/watch?v=${vid}"`, async (error, stdout, stderr) => {
      if (error) {
        console.error(`Error: ${error.message}`);
        return await message.send('*Failed to download audio.*', {
          quoted: message.data,
        });
      }

      // Add audio metadata and send audio
      const buffer = fs.readFileSync(outputPath);
      const audioMetaData = await addAudioMetaData(buffer, vid, '', '', `https://i.ytimg.com/vi/${vid}/hqdefault.jpg`);
      await message.send(audioMetaData, { quoted: message.data, mimetype: 'audio/mpeg' }, 'audio');

      // Cleanup
      fs.unlinkSync(outputPath);
    });
  }
);
