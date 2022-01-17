const childProcess = require("child_process");
const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const readline = require("readline");

const osPath = path.resolve(__dirname, "../.os");
const configPath = path.resolve(__dirname, "../lb/config");
const downloadedDebs = path.resolve(osPath, ".debs");
const DEB_REGEX = /[^:]+:\/\/.+\.deb$/g;

function download(url, file) {
  return new Promise((resolve, reject) => {
    childProcess.exec(
      `mkdir -p ${downloadedDebs} && curl -Lo ${path.resolve(
        downloadedDebs,
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

function removeFiles(filePaths) {
  filePaths.forEach((filePath) => {
    if (fs.existsSync(filePath)) {
      fs.rmSync(filePath);
    }
  });
}

function cleanPackages() {
  removeFiles([
    path.resolve(configPath, "package-lists/packages.list.chroot_install"),
    path.resolve(configPath, "package-lists/packages.list.chroot_live"),
    path.resolve(configPath, "package-lists/packages.list.binary"),
  ]);
}

function loadPackage(package) {
  if (DEB_REGEX.test(package.package)) {
    return download(
      package.package,
      `${crypto.createHash("md5").update(package.package).digest("hex")}.deb`
    ).then((result) => {
      console.log(`downloaded package ${package.package}`);
      return result;
    });
  } else {
    if (package.live && package.installed) {
      // list.chroot or list.chroot_install
      fs.appendFileSync(
        path.resolve(configPath, "package-lists/packages.list.chroot_install"),
        `${package.package.trim()}\n`
      );
    } else if (package.live && !package.installed) {
      // list.chroot_live
      fs.appendFileSync(
        path.resolve(configPath, "package-lists/packages.list.chroot_live"),
        `${package.package.trim()}\n`
      );
    } else if (!package.live && package.installed) {
      // add to calamares/modules/packages.conf and includes.installer/preseed.cfg
      fs.appendFileSync(
        path.resolve(configPath, "package-lists/packages.list.install"),
        `${package.package.trim()}\n`
      );
    }
    if (package.binary) {
      // list.binary
      fs.appendFileSync(
        path.resolve(configPath, "package-lists/packages.list.binary"),
        `${package.package.trim()}\n`
      );
    }
    console.log(`loaded package ${package.package}`);
  }
}

function loadPackages() {
  if (!fs.existsSync(configPath)) fs.mkdirSync(configPath);
  if (!fs.existsSync(path.resolve(configPath, "package-lists"))) {
    fs.mkdirSync(path.resolve(configPath, "package-lists"));
  }
  return stdin()
    .then((data) => {
      JSON.parse(data).forEach((package) => {
        if (typeof package !== "string") return loadPackage(package);
        return loadPackage({
          binary: false,
          installed: true,
          live: true,
          package: package,
        });
      });
    })
    .catch(console.error);
}

module.exports = {
  clean: cleanPackages,
  load: loadPackages,
};
