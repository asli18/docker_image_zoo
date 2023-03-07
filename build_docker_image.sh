#!/bin/bash

usage() {
    echo -e "Usage: ./build_docker_image.sh -t=TYPE -v=VER"
    echo -e "  -h, --help"
    echo -e "         display this help and exit\n"
    echo -e "  -v, --version=VER"
    echo -e "         ubuntu version, VER: 18, 20, 22\n"
    echo -e "  -t, --type=TYPE"
    echo -e "         image type, TYPE: sample, lib, env\n"
    echo -e "Example:"
    echo -e "  ./build_docker_image.sh -t=sample -v=20"
    echo -e "  ./build_docker_image.sh -t=lib -v=22"
    echo -e "  ./build_docker_image.sh -t=env -v=22"
}

main() {
    local version
    local image_type

    while [ "$1" != "" ]; do
        PARAM=`echo $1 | awk -F= '{print $1}'`
        VALUE=`echo $1 | awk -F= '{print $2}'`
        case $PARAM in
            -h | --help)
                usage
                exit 0
                ;;
            -v | --version)
                if ! [ "$VALUE" = "18" ] &&
                   ! [ "$VALUE" = "20" ] &&
                   ! [ "$VALUE" = "22" ]; then
                    echo "Error: invalid ubuntu version \"$VALUE\""
                    usage
                    exit 1
                fi

                version="$VALUE"
                ;;
            -t | --type)
                if ! [ "${VALUE}" = "sample" ] &&
                   ! [ "${VALUE}" = "lib" ] &&
                   ! [ "${VALUE}" = "env" ]; then
                    echo "Error: invalid build type \"$VALUE\""
                    usage
                    exit 1
                fi

                image_type="${VALUE}"
                ;;
            *)
                echo "Error: unknown parameter \"$PARAM\""
                usage
                exit 1
                ;;
        esac
        shift
    done

    if [ -z ${version} ] || [ -z ${image_type} ]; then
        echo "Error: invalid input parameter"
        usage
        exit 1
    fi

    build_image
}

build_image() {
    local start_time=$(date +%s)

    local ubuntu_ver="${version}.04"

    local image_name="${image_type}"
    local image_tag="ubuntu${ubuntu_ver}"

    local dockerfile="./Dockerfiles/${image_type}/ubuntu${ubuntu_ver}/Dockerfile"
    if [ ! -f "${dockerfile}" ]; then
        echo -e "Error: Dockerfile not found, \"${dockerfile}\""
        exit 1
    fi

    echo -e "Build docker image \033[33m${image_name}:${image_tag}\033[0m"
    echo -e "with Dockerfile: \033[32m${dockerfile}\033[0m"
    echo -e "----------------------------------------------------------------"

    local cmd="docker build"
    cmd+=" -f ${dockerfile} --no-cache"
    cmd+=" -t ${image_name}:${image_tag}"
    cmd+=" --build-arg UBUNTU_VER=${ubuntu_ver}"
    cmd+=" ."

    echo "${cmd}"
    eval "${cmd}"
    #docker build -f ${dockerfile} --no-cache \
    #             -t ${image_name}:${image_tag} \
    #             --build-arg UBUNTU_VER=${ubuntu_ver} \
    #             .

    local err=$?
    local end_time=$(date +%s)
    local elapsed=$((end_time - start_time))

    echo -e "\n----------------------------------------------------------------"
    echo -e "Build docker image \033[33m${image_name}:${image_tag}\033[0m complete."
    eval "echo Total Elapsed time: $(date -ud "@$elapsed" +'%H hr %M min %S sec \(%s s\)')"
    echo ""

    if [ ${err} -ne 0 ]; then
        echo -e "Build docker image failed"
        exit 1
    fi
}

main ${@}
