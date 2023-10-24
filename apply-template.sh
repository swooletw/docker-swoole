#!/usr/bin/env bash

dockerfile_template=templates/Dockerfile
ci_script_template=templates/build.yml
dockerfiles_path=dockerfiles
ci_script_path=.github/workflows/build.yml
versions=`cat versions.txt`

get_swoole_version() {
  echo ${1} | awk -F'@' '{print $1}'
}

get_php_version() {
  echo ${1} | awk -F'@' '{print $2}'
}

build_dockerfiles() {
  for version in ${versions}; do
    swoole=`get_swoole_version ${version}`
    php=`get_php_version ${version}`
    path=${dockerfiles_path}/${swoole}/php${php}
    dockerfile_path=${path}/Dockerfile

    mkdir -p ${path}

    cat ${dockerfile_template} | sed "s/{{SWOOLE_VERSION}}/${swoole}/g" | sed "s/{{PHP_VERSION}}/${php}/g" > ${dockerfile_path}

    echo ${dockerfile_path} built
  done
}

build_ci_script() {
  martix=''

  for version in ${versions}; do
    swoole=`get_swoole_version ${version}`
    php=`get_php_version ${version}`

    martix="${martix}\n          - php: ${php}\n            swoole: ${swoole}"
  done

  cat ${ci_script_template} | sed "s/{{MATRIX}}/${martix}/g" > ${ci_script_path}

  echo ${ci_script_path} built
}

main() {
  build_dockerfiles
  build_ci_script
  echo done
}

main
