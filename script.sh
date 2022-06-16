#!/bin/sh
version=0.9.27

apply() {
	cd tcc-$version
	patch -p1 < ../patches/$1.patch
}


build() {
	cd tcc-$version
	./configure --prefix="$(readlink -f ../out)"
	make
	make install

	cd ..
	ln -sf out/bin/tcc tcc
}

clear() {
	rm -rf tcc tcc-$version out
}

init() {
	wget http://download.savannah.gnu.org/releases/tinycc/tcc-$version.tar.bz2
	tar fvx tcc-$version.tar.bz2 && rm tcc-$version.tar.bz2

	cd tcc-$version
	patch -p1 << EOF
diff --git a/lib/bcheck.c b/lib/bcheck.c
index 90f0ad2..31332fd 100644
--- a/lib/bcheck.c
+++ b/lib/bcheck.c
@@ -47,7 +47,7 @@
 /* #define BOUND_STATIC */
 
 /* use malloc hooks. Currently the code cannot be reliable if no hooks */
-#define CONFIG_TCC_MALLOC_HOOKS
+// #define CONFIG_TCC_MALLOC_HOOKS
 #define HAVE_MEMALIGN
 
 #if defined(__FreeBSD__) \
-- 
2.36.1
EOF
}

case $1 in
    apply) apply $2 ;;

    build) build ;;

	clear) clear ;;

    init) init ;;

    *) ;;
esac
