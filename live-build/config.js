var readline = require("readline");

var rl = readline.createInterface({
  input: process.stdin,
});

function stdin() {
  return new Promise((resolve, reject) => {
    try {
      let stdin = "";
      rl.on("line", (line) => (stdin += line));
      rl.on("close", () => resolve(stdin));
    } catch (err) {
      return reject(err);
    }
  });
}

stdin()
  .then((data) => {
    console.log(
      JSON.parse(data).map((package) => {
        if (typeof package !== "string") return package;
        return {
          name: package,
          live: true,
          installed: true,
          binary: false,
        };
      })
    );
  })
  .catch(console.error);
