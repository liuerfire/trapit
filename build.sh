#!/bin/sh

set -e

SOURCE_DIR="$(pwd)"
BUILD_DIR="${SOURCE_DIR}/build"
BUILD_BIN="trapit"

if ! [ -f "${SOURCE_DIR}/CMakeLists.txt" ]; then
  printf >&2 'ERROR: %s is not the source directory which includes %s' \
    "${SOURCE_DIR}" "CMakeLists.txt"
  exit 2
fi

cmake_configure() {
  cmake -S "${SOURCE_DIR}" -B "${BUILD_DIR}" "$@"
}

cmake_build() {
  cmake --build "${BUILD_DIR}"
}

cmd_help() {
  printf >&2 'Usage: %s [help|clean|build|run]\n' "$0"
}

cmd_clean() {
  set -x
  rm -rf "${BUILD_DIR}"
}

cmd_build() {
  set -x
  if [ -z "$(command -v ninja)" ]; then
    cmake_configure
  else
    cmake_configure -G Ninja
  fi
  cmake_build
}

cmd_run() {
  cmd_build
  exec "${BUILD_DIR}/${BUILD_BIN}"
}

case "$1" in
  help)
    cmd_help
    ;;
  clean)
    cmd_clean
    ;;
  build)
    cmd_build
    ;;
  run)
    cmd_run
    ;;
  *)
    cmd_help
    exit 2
    ;;
esac
