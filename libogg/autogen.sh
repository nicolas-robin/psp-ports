#!/bin/sh
# Run this to set up the build system: configure, makefiles, etc.
# (based on the version in enlightenment's cvs)

package="libogg"

olddir=`pwd`
srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

cd "$srcdir"
DIE=0

AUTOCONF=autoconf
AUTOMAKE=automake
ACLOCAL=aclocal
AUTOHEADER=autoheader

echo "checking for $AUTOCONF... "
($AUTOCONF --version) < /dev/null > /dev/null 2>&1 || {
        echo
        echo "You must have autoconf installed to compile $package."
        echo "Download the appropriate package for your distribution,"
        echo "or get the source tarball at ftp://ftp.gnu.org/pub/gnu/"
        DIE=1
}

echo "checking for $AUTOMAKE... "
($AUTOMAKE --version) < /dev/null > /dev/null 2>&1 || {
        echo
        echo "You must have automake installed to compile $package."
        echo "Download the appropriate package for your system,"
        echo "or get the source from one of the GNU ftp sites"
        echo "listed in http://www.gnu.org/order/ftp.html"
        DIE=1
}

echo -n "checking for libtool... "
for LIBTOOLIZE in libtoolize glibtoolize nope; do
  ($LIBTOOLIZE --version) < /dev/null > /dev/null 2>&1 && break
done
if test x$LIBTOOLIZE = xnope; then
  echo "nope."
  LIBTOOLIZE=libtoolize
else
  echo $LIBTOOLIZE
fi
($LIBTOOLIZE --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have libtool installed to compile $package."
	echo "Download the appropriate package for your system,"
	echo "or get the source from one of the GNU ftp sites"
	echo "listed in http://www.gnu.org/order/ftp.html"
	DIE=1
}

if test "$DIE" -eq 1; then
        exit 1
fi

if test -z "$*"; then
        echo "I am going to run ./configure with no arguments - if you wish "
        echo "to pass any to it, please specify them on the $0 command line."
fi

echo "Generating configuration files for $package, please wait...."

echo "  $ACLOCAL $ACLOCAL_FLAGS"
$ACLOCAL $ACLOCAL_FLAGS || exit 1
echo "  $LIBTOOLIZE --automake"
$LIBTOOLIZE --automake || exit 1
echo "  $AUTOHEADER"
$AUTOHEADER || exit 1
echo "  $AUTOMAKE --add-missing $AUTOMAKE_FLAGS"
$AUTOMAKE --add-missing $AUTOMAKE_FLAGS || exit 1
echo "  $AUTOCONF"
$AUTOCONF || exit 1

cd $olddir
$srcdir/configure --enable-maintainer-mode "$@" && echo
