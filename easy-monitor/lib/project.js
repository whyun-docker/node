const path = require('path');
const startCluster = require('egg').startCluster;

const {
  DISABLE_CONSOLE,
  DISABLE_MANAGER,
  DISABLE_WSSERVER,
  CONSOLE_PORT,
  MANAGER_PORT,
  WSS_PORT,
} = process.env;

let projectNum = 0;

const base = {
  workers: 1,
  baseDir: path.join(__dirname, '..'),
  env: process.env.EZM_ENV ? process.env.EZM_ENV : 'prod',
};

function start(name, options, cb) {
  ++projectNum;
  options = Object.assign({ serverScope: name }, base, options);
  startCluster(options, () => {
    console.log(`=========> [${process.pid}] ${name} started on ${options.port}.`);
    if (--projectNum === 0) {
      cb();
    }
  });
}

module.exports = function(cb) {
  // ezmconsole
  if (DISABLE_CONSOLE !== 'YES') {
    start('console', {
      port: Number(CONSOLE_PORT) || 8443,
      framework: path.dirname(require.resolve('@xprofiler/console')),
    }, cb);
  }

  // ezmmanager
  if (DISABLE_MANAGER !== 'YES') {
    start('manager', {
      port: Number(MANAGER_PORT) || 8543,
      framework: path.dirname(require.resolve('@xprofiler/manager')),
    }, cb);
  }

  // ezmwsserver
  if (DISABLE_WSSERVER !== 'YES') {
    start('wsserver', {
      port: Number(WSS_PORT) || 9190,
      framework: path.dirname(require.resolve('@xprofiler/wsserver')),
    }, cb);
  }
};
