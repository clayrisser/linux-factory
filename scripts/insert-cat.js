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

stdin()
  .then((stdinData) => {
    const filePath = path.resolve(process.argv[2] || "");
    if (fs.lstatSync(filePath).isFile()) {
      return new Promise((resolve, reject) => {
        fs.readFile(filePath, (err, fileData) => {
          if (err) return reject(err);
          fileData = fileData.toString();
          if (process.argv.length > 3) {
            const match = fileData.match(new RegExp(process.argv[3]));
            const index = match.index + match[0].length;
            console.log(
              fileData.slice(0, index) + stdinData + fileData.slice(index)
            );
          } else {
            console.log(fileData + stdinData);
          }
          return resolve();
        });
      });
    }
  })
  .catch(console.error);
