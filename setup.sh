#!/usr/bin/env sh

ARCI_DIR="$DESTDIR/etc/arci.d"
ARCI_DIRS="$ARCI_DIR $DESTDIR/usr/bin $DESTDIR/etc/rc.d $DESTDIR/lib/arci"

log() { echo " :: $1"; }

main() {
    log 'Making arci directories'
    for dir in $ARCI_DIRS; do
        install -d -m 755 -- "$dir"
    done

    log 'Installing arci'
    install -m754 src/* "$ARCI_DIR"
    install -m644 inittab "$DESTDIR/etc"
    install -m644 lib/* "$DESTDIR/lib/arci"

    log 'Configuring'
    install -Dm644 arci.conf "$ARCI_DIR"
}

main "$@"
