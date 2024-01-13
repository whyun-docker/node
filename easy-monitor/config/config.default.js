const os = require('os');
const path = require('path');

const {
  EZM_SERVER,
  EZM_ID,
  EZM_SECRET,
  CONSOLE_MYSQL_HOST,
  CONSOLE_MYSQL_PORT,
  CONSOLE_MYSQL_USER,
  CONSOLE_MYSQL_PASSWORD,
  CONSOLE_MYSQL_DATABASE,

  LOGS_MYSQL_HOST,
  LOGS_MYSQL_PORT,
  LOGS_MYSQL_USER,
  LOGS_MYSQL_PASSWORD,
  LOGS_MYSQL_DATABASE,

  REDIS_SERVER,
  REDIS_PASSWORD,
  REDIS_DB,

  CONSOLE_BASE_URL,
  MANAGER_BASE_URL,
} = process.env;

module.exports = appInfo => {
  const config = {};

  config.mysql = {
    app: true,
    agent: false,
    clients: {
      xprofiler_console: {
        host: CONSOLE_MYSQL_HOST || '127.0.0.1',
        port: CONSOLE_MYSQL_PORT || 3306,
        user: CONSOLE_MYSQL_USER || 'root',
        password: CONSOLE_MYSQL_PASSWORD || '',
        database: CONSOLE_MYSQL_DATABASE || 'xprofiler_console',
      },
      xprofiler_logs: {
        host: LOGS_MYSQL_HOST || '127.0.0.1',
        port: LOGS_MYSQL_PORT || 3306,
        user: LOGS_MYSQL_USER || 'root',
        password: LOGS_MYSQL_PASSWORD || '',
        database: LOGS_MYSQL_DATABASE || 'xprofiler_logs',
      },
    },
  };
  if (!REDIS_SERVER) {
    config.redis = {
      client: {
        sentinels: null,
        port: 6379,
        host: '127.0.0.1',
        password: '',
        db: 0,
      },
    };
  } else {
    const hosts = REDIS_SERVER.split(',');
    const hostPorts = hosts.map(host => {
      const hostPort = host.split(':');
      return {
        host: hostPort[0],
        port: Number(hostPort[1]) || 6379,
      };
    });
    if (hostPorts.length === 1) {
      config.redis = {
        client: {
          sentinels: null,
          port: hostPorts[0].port,
          host: hostPorts[0].host,
          password: REDIS_PASSWORD || '',
          db: REDIS_DB || 0,
        },
      };
    } else {
      const nodes = hostPorts.map(data => {
        return {
          port: data.port,
          host: data.host,
          password: REDIS_PASSWORD || '',
          db: REDIS_DB || 0,
        };
      });
      config.redis = {
        cluster: true,
        nodes,
      };
    }
  }


  config.forceHttp = true;

  config.xprofilerConsole = CONSOLE_BASE_URL || 'http://127.0.0.1:8443';

  config.xtransitManager = MANAGER_BASE_URL || 'http://127.0.0.1:8543';

  config.xtransit = {
    server: EZM_SERVER || 'ws://127.0.0.1:9190',
    appId: EZM_ID || '',
    appSecret: EZM_SECRET || '',
    logDir: path.join(__dirname, '../logs', appInfo.scope),
    customAgent() {
      return `${os.hostname()}@${appInfo.scope}`;
    },
  };

  return config;
};
