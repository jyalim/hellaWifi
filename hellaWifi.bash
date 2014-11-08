#!/usr/bin/env bash 

polltime=60      # Seconds
logdir="${HOME}/.local/var/log"
logfile="${logdir}/hellaWifi.log"

[[ ! -d $logdir ]] && mkdir -p $logdir || :

get_router() {
  router=$(route get default | grep gateway | awk 'NR == 1{print $2}')
  echo $router
}

keep_alive() {
  router=${1:-''}
  [[ -z $router ]] && exit 100 || :
  ping -s 1 -i 1 $router &> /dev/null &
  ping_pid=$!
  echo $ping_pid
}

logging() {
  logstr=${@:-''}
  now=$(date +"%Y.%m.%d-%H.%M.%S")
  echo "[$now] -- $logstr" >> $logfile
}

daemon() {
  ppid_dir="${HOME}/.local/tmp"
  ppidfile="${ppid_dir}/hellawifi-ppid"

  [[ ! -d $ppid_dir ]] && mkdir -p $ppid_dir || :
  trap "trapped $ppidfile" 1 2 3 4 5 6 7 8 11 12 15

  logging "-----------------------------------------------------"
  logging "Starting Daemon with polltime: $polltime seconds"

  router=$(get_router)
  ppid=$(keep_alive $router)
  echo $ppid >| $ppidfile

  logging "Found router: $router"
  logging "Keeping alive with ppid: $ppid"

  while true; do
    sleep $polltime
    nrouter=$(get_router)
    if [[ $nrouter != $router ]]; then
      logging "New router: $nrouter"
      kill -9 $ppid
      logging "Killing old keep alive"
      router=$nrouter
      ppid=$(keep_alive $router)
      echo $ppid >| $ppidfile
      logging "Keeping alive with ppid: $ppid."
    fi
  done
}

trapped() {
  ppidfile=${1:-''}
  ppid=$(cat $ppidfile)
  logging "Exiting Daemon due to trap"
  logging "Killing ping with ppid: $ppid"
  kill $ppid
  rm $ppidfile
  exit 
}

daemon 
