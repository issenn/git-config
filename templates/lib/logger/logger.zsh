#!/usr/bin/env zsh


# 可将log函数单独放一个文件，通过.命令引入，这样就可以共用了


# 设置日志级别
# Logging Level configuration works as follows:
# DEBUG - Provides all logging output
# INFO  - Provides all but debug messages
# WARN  - Provides all but debug and info
# ERROR - Provides all but debug, info and warn
#
# SEVERE and CRITICAL are also supported levels as extremes of ERROR
typeset -x -A LOG_PRIORITY=(
  [NOTSET]=0
  [VERBOSE]=1
  [DEBUG]=10
  [INFO]=20
  [WARN]=30
  [WARNING]=30
  [ERROR]=40
  [FATAL]=40
  [CRITICAL]=50
  [SILENT]=100
)
# default
loglevel="INFO"


# DATETIME="`date +%Y-%m-%d` `date +%T%z`"  # Date format at beginning of log entries to match RFC
# DATE_FOR_FILENAME=`date +%Y%m%d`
# SCRIPT_LOG_DIR
# SCRIPT_LOGFILE="${SCRIPT_LOG_DIR}-APPNAME-${DATE_FOR_FILENAME}.log"

# logfile=$0".log"


function log {
  local logtype; local msg
  [[ ${#@[@]} -ne 2 ]] && return
  typeset -u logtype=$1
  msg=$2
  datetime=`date +'%F %H:%M:%S'`
  # 使用内置变量$LINENO不行，不能显示调用那一行行号
  logformat="[${logtype}]\t${datetime}\t${msg}"
  # logformat="[${logtype}]\t${datetime}\tfuncname: ${FUNCNAME[@]} [line:$LINENO]\t${msg}"
  # logformat="[${logtype}]\t${datetime}\tfuncname: ${FUNCNAME[@]/log/}\t[line:`caller 0 | awk '{print$1}'`]\t${msg}"
  # funcname格式为log error main,如何取中间的error字段，去掉log好办，再去掉main,用echo awk? ${FUNCNAME[0]}不能满足多层函数嵌套
  {
    case ${logtype} in
      DEBUG)
        [[ ${LOG_PRIORITY[${loglevel}]} -le ${LOG_PRIORITY[${logtype}]} ]] && echo -e "\033[0;35m${logformat}\033[0m" ;;
      INFO)
        [[ ${LOG_PRIORITY[${loglevel}]} -le ${LOG_PRIORITY[${logtype}]} ]] && echo -e "\033[0;32m${logformat}\033[0m" ;;
      WARN|WARNING)
        [[ ${LOG_PRIORITY[${loglevel}]} -le ${LOG_PRIORITY[${logtype}]} ]] && echo -e "\033[0;33m${logformat}\033[0m" ;;
      ERROR|CRITICAL|SEVERE)
        [[ ${LOG_PRIORITY[${loglevel}]} -le ${LOG_PRIORITY[ERROR]} ]] && echo -e "\033[0;31m${logformat}\033[0m" ;;
    esac
  } | tee -a ${logfile:-/dev/null}
}

debug() {
  local -r msg=$(msgFromHook "$@")
  log debug ${msg}
}

info() {
  local -r msg=$(msgFromHook "$@")
  log info ${msg}
}

warn() {
  local -r msg=$(msgFromHook "$@")
  log warn ${msg}
}

error() {
  local -r msg=$(msgFromHook "$@")
  log error ${msg}
}

msgFromHook() {
  [[ "${#@[@]}" -lt 1 ]] && return
  [[ "${#@[@]}" -eq 1 ]] && { local -r hook="${${hook##*/hooks/}##*/lib/}"; local -r msg="${@[@]:1:1}" }
  [[ "${#@[@]}" -gt 1 ]] && { local -r hook="${${${@[@]:(-1):1}##*/hooks/}##*/lib/}"; local -r msg="${@[@]:1:(-1)}" }
  echo -e "${msg} from ${hook}"
}
