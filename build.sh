#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Configure
SHED_PKG_LOCAL_PREFIX='/usr'
SHED_PKG_LOCAL_BINDIR='/bin'
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    SHED_PKG_LOCAL_PREFIX='/tools'
    SHED_PKG_LOCAL_BINDIR='/tools/bin'
elif [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ]; then
    sed -i 's/usr/tools/' build-aux/help2man || exit 1
fi
sed -i 's/testsuite.panic-tests.sh//' Makefile.in &&
./configure --prefix=${SHED_PKG_LOCAL_PREFIX} \
            --bindir=${SHED_PKG_LOCAL_BINDIR} &&

# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1

# Install Documentation
if [ -n "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    make html &&
    install -Dm644 doc/sed.html "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_PREFIX}/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}/sed.html"
fi
