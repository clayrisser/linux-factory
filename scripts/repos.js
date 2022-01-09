const fs = require("fs");
const path = require("path");
const readline = require("readline");

const configPath = path.resolve(__dirname, "../live-build/config");
const osPath = path.resolve(__dirname, "../os");

function stdin() {
  const rl = readline.createInterface({
    input: process.stdin,
  });
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

function cleanRepos() {}

function loadRepo(repo) {
  if (repo.live) {
    // list.chroot key.chroot
    fs.writeFileSync(
      path.resolve(configPath, `archives/${repo.name}.list.chroot`),
      `${repo.repo.trim()}\n`
    );
    if (repo.key) {
      fs.writeFileSync(
        path.resolve(configPath, `archives/${repo.name}.key.chroot`),
        `${repo.key.trim()}\n`
      );
    } else if (fs.existsSync(path.resolve(osPath, `repos/${repo.name}.key`))) {
      fs.copyFileSync(
        path.resolve(osPath, `repos/${repo.name}.key`),
        path.resolve(configPath, `archives/${repo.name}.key.chroot`)
      );
    }
  }
  if (repo.installed) {
  }
  if (repo.binary) {
    // list.binary key.binary
    fs.writeFileSync(
      path.resolve(configPath, `archives/${repo.name}.list.binary`),
      `${repo.repo.trim()}\n`
    );
    if (repo.key) {
      fs.writeFileSync(
        path.resolve(configPath, `archives/${repo.name}.key.binary`),
        `${repo.key.trim()}\n`
      );
    } else if (fs.existsSync(path.resolve(osPath, `repos/${repo.name}.key`))) {
      fs.copyFileSync(
        path.resolve(osPath, `repos/${repo.name}.key`),
        path.resolve(configPath, `archives/${repo.name}.key.binary`)
      );
    }
  }
  console.log(`loaded repo ${repo.name}`);
}

function loadRepos() {
  if (!fs.existsSync(configPath)) fs.mkdirSync(configPath);
  if (!fs.existsSync(path.resolve(configPath, "archives"))) {
    fs.mkdirSync(path.resolve(configPath, "archives"));
  }
  return stdin()
    .then((data) => {
      JSON.parse(data).forEach((repo) => {
        if (typeof repo !== "string") return loadRepo(repo);
        throw new Error("repo cannot be a string");
      });
    })
    .catch(console.error);
}

module.exports = {
  clean: cleanRepos,
  load: loadRepos,
};
