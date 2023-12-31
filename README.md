# yunnysunny/node

## 镜像

### yunnysunny/node 
基础镜像，包含 Node.js 和 yarn 命令。

### yunnysunny/node-compile 
基于 yunnysunny/node 制作，包含原生 addon 编译环境。

### yunnysunny/node-xtransit
基于 yunnysunny/node 制作，包含 xtransit 环境。
支持的环境变量包括：

| 名称                         | 说明                                                                                                                                                                                                  | 必填 |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| XTRANSIT_SERVER              | easy-monitor 的 websocket 服务的地址                                                                                                                                                                  | 是   |
| EZM_APP_ID                   | easy-monitor 的 APP ID                                                                                                                                                                                | 是   |
| EZM_SECRET                   | easy-monitor 的 APP 密钥                                                                                                                                                                              | 是   |
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


## 版本

- 18.19.0
