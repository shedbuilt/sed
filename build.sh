#!/bin/bash
sed -i 's/usr/tools/' build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in
./configure --prefix=/usr --bindir=/bin
make -j $SHED_NUMJOBS
make html
make DESTDIR=${SHED_FAKEROOT} install
install -d -m755 ${SHED_FAKEROOT}/usr/share/doc/sed-4.4
install -m644 doc/sed.html ${SHED_FAKEROOT}/usr/share/doc/sed-4.4
