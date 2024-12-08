# node 镜像
github 地址：https://github.com/whyun-docker/node

## 镜像

### yunnysunny/node 
基础镜像，包含 Node.js 和 yarn、pnpm 命令，并且配置使用阿里源来加速 npm 包安装过程。

### yunnysunny/node-compile 
基于 yunnysunny/node 制作，包含原生 addon 编译环境。

### yunnysunny/node-xtransit
基于 yunnysunny/node 制作，包含 xtransit 环境。
支持的环境变量包括：

| 名称                         | 说明                                                                                                                                                                                                  | 必填 |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| XTRANSIT_SERVER              | easy-monitor 的 websocket 服务的地址                                                                                                                                                                  | 是   |
| EZM_APP_ID                   | easy-monitor 的 APP ID                                                                                                                                                                                | 是   |
| EZM_APP_SECRET                   | easy-monitor 的 APP 密钥                                                                                                                                                                              | 是   |
| EZM_DISKS                    | 磁盘列表，用于 easy-monitor 分析磁盘占用使用，多个磁盘路径之间使用 `,` 分隔                                                                                                                           | 否   |
| EZM_ERRORS                   | 错误日志存放全路径，用于 easy-monitor 分析错误日志用，多个路径之间使用 `,` 分隔                                                                                                                       | 否   |
| EZM_PACKAGES                 | package.json 文件存放全路径，多个路径之间使用 `,` 分隔（平级路径中要包含package-lock.json 或者 yarn.lock）                                                                                            | 否   |
| EZM_LOG_DIR                  | xprofiler 插件生成性能日志文件的目录，默认两者均为 os.tmpdir()                                                                                                                                        | 否   |
| EZM_DOCKER                   | 系统数据采集会依赖当前是否是 docker 环境而进行一些特殊处理，可以手动强制指定当前实例是否为 docker 环境，手动设置为 `true` 则代表强制设置当前环境为 docker 环境                                        | 否   |
| EZM_IP_MODE                  | 默认仅使用 hostname 作为 agentId，将其设置 为 `true` ,则   agentId 组装形式为 `${ip}_${hostname}`                                                                                                     | 否   |
| EZM_ERR_EXP                  | 匹配错误日志起始的正则，默认为匹配到 YYYY-MM-DD HH:mm:ss 时间戳即认为是一条错误日志的起始；可以手动指定其他正则表达式，正则的格式为 `/正则表达式/flag`, 例如 `/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/i` | 否   |
| ENV_EZM_LOGGER_PROVIDER_FILE | 自定义 logger 对象文件                                                                                                                                                                                | 否   |
| EZM_LOG_LEVEL                | logger 的日志级别，0 error，1 info，2 warning，3 debug，默认为 2                                                                                                                                      | 否   |
| EZM_TITLES                   | 如果应用使用了 process.title 自定义了名称，可以通过配置这里上报进程数据, 使用 `,` 分隔多个 title 数据                                                                                                 | 否   |
| EZM_COMMANDS                 | 可以配置多个自定义的 easy-monitor 用的 command 目录，使用 `,` 分隔                                                                                                                                    | 否   |
| EZM_CLEAN_AFTER_UPLOAD       | 设置为 `true`，则会在转储本地性能文件成功后删除本地的性能文件                                                                                                                                         | 否   |
|EZM_CUSTOM_AGENT_PROVIDER_FILE| 自定义 agent id 的获取的 js 文件 |  否    |

### yunnysunny/easy-monitor
基于 yunnysunny/node 制作，包含 easy-monitor 中的 [xprofiler-console](https://github.com/X-Profiler/xprofiler-console) [xtransit-manager](https://github.com/X-Profiler/xtransit-manager) [xtransit-server](https://github.com/X-Profiler/xtransit-server) 三个服务。
由于在一个容器中放置了三个服务的代码，所以牵扯到环境变量有些多。其中 `CONSOLE_MYSQL_` 开头的变量对应的数据库是用来存储应用和用户相关数据的，`LOGS_MYSQL_` 开头的变量对应的数据库是用来存储性能日志相关数据的。同时这三个服务还会用到 redis 来缓存数据，所以需要根据需要提供 `REDIS_` 开头的环境变量。
CONSOLE_BASE_URL 这个环境变量需要特殊注意一下，console 服务在通知集成 xprofiler 应用上传性能分析文件时，会讲此变量通过 websocket 发给集成应用，所以这个变量一定要保证集成应用能够正常访问，否则性能收集文件无法上传到 console 服务中。
支持的环境变量变量列表总结如下：

| 名称 | 说明 | 默认 | 必填 |
| ---- | ---- | ---- | ---- |
| CONSOLE_MYSQL_HOST | 用户、应用数据库使用的mysql服务的ip或者域名 | 127.0.01 | 否 |
| CONSOLE_MYSQL_PORT | 用户、应用数据库使用的mysql服务的端口号 | 3306 | 否 |
| CONSOLE_MYSQL_USER | 用户、应用数据库使用的mysql服务的用户名 | root | 否 |
| CONSOLE_MYSQL_PASSWORD | 用户、应用数据库使用的mysql服务的密码 | 空字符串 | 否 |
| LOGS_MYSQL_DATABASE | 用户、应用数据库使用的mysql服务的数据库名 | `xprofiler_console` | 否 |
| LOGS_MYSQL_HOST | 性能日志数据库使用的mysql服务的ip或者域名 | 127.0.01 | 否 |
| LOGS_MYSQL_PORT | 性能日志数据库使用的mysql服务的端口号 | 3306 | 否 |
| LOGS_MYSQL_USER | 性能日志数据库使用的mysql服务的用户名 | root | 否 |
| LOGS_MYSQL_PASSWORD | 性能日志数据库使用的mysql服务的密码 | 空字符串 | 否 |
| LOGS_MYSQL_DATABASE | 性能日志数据库使用的mysql服务的数据库名 | `xprofiler_logs` | 否 |
| REDIS_SERVER | redis 服务器的地址，格式为`ip1:port1[,ip2:port2]`，如果只传入一个 ip+端口号，则代表当前出于单点模式，否则代表当前出于集群模式，暂不支持哨兵模式 | 127.0.0.1:6379 | 否 |
| REDIS_PASSWORD | redis 服务的访问密码 | 空字符串 | 否 |
| REDIS_DB | redis db 的索引 | 0 | 否 |
| CONSOLE_BASE_URL | console 服务的访问地址，目前会在上传性能分析文件中用到，这里给出的默认值只做本地测试时才有用，正式使用时要保证接入 easy-monitor 的应用能够访问到。 | http://127.0.0.1:8443 | 否 |
| CONSOLE_PORT | xprofiler-console 服务的监听端口 | 8443 | 否 |
| MANAGER_PORT | xtransit-manager 服务的监听端口 | 8543 | 否 |
| WSS_PORT | xtransit-server 服务的监听端口 | 9190 | 否 |

## 版本
> `x.y.z` 版本号在推送的时候，会级联推送 `x.y` 和 `x` 版本。

- 16.20.2
- 18.20.5
- 20.18.1
- 22.12.0
