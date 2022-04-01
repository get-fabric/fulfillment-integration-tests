var fs = require("fs");

const args = process.argv.slice(2);
const deployment_folder = args[0]

var services_cluster = new Set(
  fs
    .readFileSync(
      `./services_cluster`
    )
    .toString("utf-8")
    .split("\n")
);
var services_folder = new Set(
  fs
    .readFileSync(
      `./services_folder`
    )
    .toString("utf-8")
    .split("\n")
);

fs.writeFileSync(
  `./services_cluster_missing_from_folder`,
  [
    ...new Set([...services_cluster].filter((x) => !services_folder.has(x))),
  ].join("\n")
);
