#!/bin/sh
#
#  Copyright 2014-2016 CyberVision, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

# Exits immediately if error occurs
set -e

RUN_DIR=`pwd`

help() {
    echo "Choose one of the following: {build|run|deploy|clean}"
    exit 1
}

if [ $# -eq 0 ]
then
    help
fi

APP_NAME="demo_client"
PROJECT_HOME=$(pwd)
BUILD_DIR="build"
KAA_TOOLCHAIN_PATH_SDK=""

build_app() {
    cd "$PROJECT_HOME"
    mkdir -p "$PROJECT_HOME/$BUILD_DIR"
    cd "$BUILD_DIR"
    cmake -DWITH_EXTENSION_EVENT=OFF \
          -DWITH_EXTENSION_LOGGING=OFF \
          -DKAA_MAX_LOG_LEVEL=3 \
          $KAA_TOOLCHAIN_PATH_SDK ..
    make

}

clean() {
    rm -rf "$PROJECT_HOME/$BUILD_DIR"
}

run() {
    echo "Endpoint profiles and grouping demo started"
    ./../$BUILD_DIR/$APP_NAME "-" "-" "+" "1" &
    ./../$BUILD_DIR/$APP_NAME "+" "-" "+" "2" &
    ./../$BUILD_DIR/$APP_NAME "+" "+" "+" "3"
    wait 
    echo "Endpoint profiles and grouping demo stopped"
}

for cmd in $@
do

case "$cmd" in
    build)
        build_app
    ;;

    run)
        run
    ;;

    deploy)
        clean
        build_app
        run
    ;;

    clean)
        clean
    ;;

    *)
        help
    ;;
esac

done