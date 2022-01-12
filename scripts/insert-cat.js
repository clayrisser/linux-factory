const fs = require("fs");
const path = require("path");
const readline = require("readline");

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

write = console.log;
const filePath = path.resolve(process.argv[2] || "");
if (new Set(process.argv).has("-i")) {
  write = (data) => fs.writeFileSync(filePath, data);
}

stdin()
  .then((stdinData) => {
    if (fs.lstatSync(filePath).isFile()) {
      return new Promise((resolve, reject) => {
        fs.readFile(filePath, (err, fileData) => {
          if (err) return reject(err);
          fileData = fileData.toString();
          if (process.argv.length > 3) {
            const match = fileData.match(new RegExp(process.argv[3]));
            if (!match) {
              write(fileData);
              return resolve();
            }
            const index = match.index + match[0].length;
            write(
              fileData.slice(0, index) +
                stdinData.slice(0, stdinData.length - 1) +
                fileData.slice(index)
            );
          } else {
            write(fileData + stdinData);
          }
          return resolve();
        });
      });
    }
  })
  .catch(console.error);
