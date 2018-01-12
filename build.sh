#!/bin/bash
case "$SHED_BUILDMODE" in
    toolchain)
        ./configure --prefix=/tools || return 1
        make -j $SHED_NUMJOBS || return 1
        make DESTDIR="$SHED_FAKEROOT" install || return 1
        ;;
    *)
        sed -i 's/usr/tools/' build-aux/help2man
        sed -i 's/testsuite.panic-tests.sh//' Makefile.in
        ./configure --prefix=/usr --bindir=/bin || return 1
        make -j $SHED_NUMJOBS || return 1
        make html || return 1
        make DESTDIR="$SHED_FAKEROOT" install || return 1
        install -d -m755 "${SHED_FAKEROOT}/usr/share/doc/sed-4.4"
        install -m644 doc/sed.html "${SHED_FAKEROOT}/usr/share/doc/sed-4.4"
        ;;
esac
