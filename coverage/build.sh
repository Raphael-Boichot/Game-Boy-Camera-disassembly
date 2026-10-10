#!/bin/sh
# Linux/macOS:  ./build.sh        Windows (MinGW):  gcc -O2 -shared -o src/gbcov.dll src/gbcov.c
set -e
cd "$(dirname "$0")/src"
case "$(uname -s)" in
  Darwin) cc -O2 -shared -fPIC -o libgbcov.dylib gbcov.c ;;
  MINGW*|MSYS*|CYGWIN*) gcc -O2 -shared -o gbcov.dll gbcov.c ;;
  *) cc -O2 -shared -fPIC -o libgbcov.so gbcov.c ;;
esac
echo built
