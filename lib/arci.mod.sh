export LOCKDIRS='/run/lock /dev/pts /dev/shm'
export VFS_FLAGS='nosuid,noexec,nodev'
export DFS_FLAGS='mode=0755,nosuid'
export ARCI_DIR='/etc/arci.d'
export ARCI_SDIR='/etc/arci.sv.d'
export ARCI_VERSION='0x1'

log() { printf ' :: %s... ' "$1"; }
elog() { echo "$1"; }
slog() { echo " ** $1 **"; }

do_udev() {
    udevd --daemon
    udevadm trigger --action=add --type=subsystems
    udevadm trigger --action=add --type=devices
    udevadm trigger --action=change --type=devices
    udevadm settle
}

do_service() {
    if [ "$PREVLEVEL" = '2' ]; then
        if [ "$SERVICES" ]; then
            for service in $SERVICES; do
                _SERVICES="$service $R_DAEMONS"
            done

            for service in $_SERVICES; do
                [ -x "$ARCI_SDIR/$service" ] && "$ARCI_SDIR/$service" "$1"
            done
        fi
    fi

}

do_noproc() {
    log 'Terminating all processes'
    killall5 -15
    sleep 1
    elog 'done'

    log 'Killing all processes'
    killall5 -9
    elog 'done'
}

do_hwclock() {
    log 'Syncing hardware clock'
    hwclock --hctosys
    elog 'synced'
}
