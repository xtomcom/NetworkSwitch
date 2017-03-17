#!/bin/sh
### BEGIN INIT INFO
# Provides:          xtom-network-switch
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the xtom network switch
# Description:       starts xtom network switch using start-stop-daemon
### END INIT INFO

PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

NAME=xtom-network-switch
PID_FILE="/var/run/$NAME.pid"
DAEMON="/opt/xtom-network-switch/network-switch"

WORK_DIR="$(dirname "$DAEMON")"

start() {
	echo "Starting daemon: $NAME"
	start-stop-daemon \
		--start --quiet --background \
		--pidfile ${PID_FILE} --make-pidfile \
		--exec ${DAEMON} \
		--chdir ${WORK_DIR}
}

stop() {
	echo "Stopping daemon: $NAME"
	start-stop-daemon \
		--stop \
		--quiet \
		--oknodo \
		--pidfile ${PID_FILE}
}

restart() {
	start-stop-daemon \
		--stop \
		--quiet \
		--oknodo \
		--retry 30 \
		--pidfile ${PID_FILE}
	start-stop-daemon \
		--start --quiet --background \
		--pidfile ${PID_FILE} --make-pidfile \
		--exec ${DAEMON} \
		--chdir ${WORK_DIR}
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		restart
		;;
	*)
		echo "Usage: $1 {start|stop|restart}"
		exit 1
		;;
esac

exit 0
