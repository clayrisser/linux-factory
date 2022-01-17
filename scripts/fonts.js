const childProcess = require("child_process");
const fs = require("fs");
const path = require("path");
const readline = require("readline");

const FONT_REGEX = /[^:]+:\/\/.+$/g;
const configPath = path.resolve(__dirname, "../lb/config");
const osPath = path.resolve(__dirname, "../.os");
const downloadedFonts = path.resolve(osPath, ".fonts");

function stdin() {
  const rl = readline.createInterface({
    input: process.stdin,
  });
  return new Promise((resolve, reject) => {
    try {
      let stdin = "";
      rl.on("line", (line) => (stdin += line + "\n"));
      rl.on("close", () => resolve(stdin));
    } catch (err) {
      return reject(err);
    }
  });
}

function download(url, file) {
  return new Promise((resolve, reject) => {
    childProcess.exec(
      `mkdir -p ${downloadedFonts} && curl -Lo ${path.resolve(
        downloadedFonts,
        file
      )} ${url}`,
      (err, stdout, stderr) => {
        if (err) return reject(err);
        if (stderr) {
          if (stderr.toString().indexOf("% Total") <= -1) {
            return reject(new Error(stderr.toString()));
          }
        }
        return resolve(stdout);
      }
    );
  });
}

function cleanFonts() {}

function loadFont(font) {
  if (FONT_REGEX.test(font.font)) {
    if (font.live) {
      const fontFileName = Array.from(font.font.match(/[^/]+$/g) || []).join(
        ""
      );
      return download(font.font, `live/${fontFileName}`).then((result) => {
        console.log(`downloaded font ${font.font}`);
        if (font.installed) {
          fs.appendFileSync(
            path.resolve(downloadedFonts, "installed/fonts.list"),
            font.font
          );
        }
        return result;
      });
    }
    if (font.installed) {
      fs.appendFileSync(
        path.resolve(downloadedFonts, "installed/fonts.list"),
        font.font
      );
    }
  } else {
    const fontPath = path.resolve(osPath, "fonts", font.font);
    if (fs.existsSync(fontPath)) {
      if (font.installed) {
        fs.copyFileSync(
          fontPath,
          path.resolve(downloadedFonts, "installed", font.font)
        );
      }
      if (font.live) {
        fs.copyFileSync(
          fontPath,
          path.resolve(downloadedFonts, "live", font.font)
        );
      }
      fs.unlinkSync(fontPath);
      console.log(`loaded font ${font.font}`);
    }
  }
}

function loadFonts() {
  const localFontsSet = new Set(
    fs.readdirSync(path.resolve(osPath, "fonts")).reduce((files, fileName) => {
      if (!/\.yaml$/.test(fileName)) files.push(fileName);
      return files;
    }, [])
  );
  if (!fs.existsSync(configPath)) fs.mkdirSync(configPath);
  if (!fs.existsSync(downloadedFonts)) fs.mkdirSync(downloadedFonts);
  if (!fs.existsSync(path.resolve(downloadedFonts, "live"))) {
    fs.mkdirSync(path.resolve(downloadedFonts, "live"));
  }
  if (!fs.existsSync(path.resolve(downloadedFonts, "installed"))) {
    fs.mkdirSync(path.resolve(downloadedFonts, "installed"));
  }
  return stdin()
    .then((data) => {
      return Promise.all(
        JSON.parse(data).map((font) => {
          if (typeof font !== "string") {
            localFontsSet.delete(font.font);
            return loadFont(font);
          }
          localFontsSet.delete(font);
          return loadFont({
            font: font,
            live: true,
            installed: true,
          });
        })
      );
    })
    .then(() => {
      return Promise.all(
        Array.from(localFontsSet).map((font) => {
          return loadFont({
            font: font,
            live: true,
            installed: true,
          });
        })
      );
    })
    .catch(console.error);
}

module.exports = {
  clean: cleanFonts,
  load: loadFonts,
};
