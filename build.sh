#!/bin/bash
case "$SHED_BUILD_MODE" in
    toolchain)
        ./configure --prefix=/tools &&
        make -j $SHED_NUM_JOBS &&
        make DESTDIR="$SHED_FAKE_ROOT" install || exit 1
        ;;
    *)
        sed -i 's/usr/tools/' build-aux/help2man &&
        sed -i 's/testsuite.panic-tests.sh//' Makefile.in &&
        ./configure --prefix=/usr --bindir=/bin &&
        make -j $SHED_NUM_JOBS || exit 1
        if $SHED_INSTALL_DOCS; then
            make html || exit 1
        fi
        make DESTDIR="$SHED_FAKE_ROOT" install || exit 1
        if $SHED_INSTALL_DOCS; then
            install -d -m755 "${SHED_FAKE_ROOT}/usr/share/doc/sed-${SHED_PKG_VERSION}" &&
            install -m644 doc/sed.html "${SHED_FAKE_ROOT}/usr/share/doc/sed-${SHED_PKG_VERSION}"
        fi
        ;;
esac
